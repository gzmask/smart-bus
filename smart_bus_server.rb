require 'location_distributor.rb'
require 'includes/bus.rb'
require 'includes/passenger.rb'
require 'includes/location.rb'
require 'includes/db.rb'
require 'map_quest.rb'
require 'SmartBusWeb/app/models/web_bus.rb'
require 'SmartBusWeb/app/models/web_passenger.rb'
require 'SmartBusWeb/app/models/web_location.rb'
require 'SmartBusWeb/app/models/web_lock.rb'
require 'smart_bus_server_once.rb'
require 'reroute.rb'

def find_dis(loc1, loc2)
	return (2**(0.size * 8 -2)-1) if loc1 == nil || loc2 == nil
	lat_dif = (loc1.latitude - loc2.latitude).abs
	lng_dif = (loc1.longitude - loc2.longitude).abs
	return Math.sqrt(lat_dif*lat_dif + lng_dif*lng_dif)
end

$minLocationNum = WebBus.count * 4

while true
	sleep 5
	web_lock = WebLock.find_by_resource("web_location")
	web_lock.in_use = true
	web_lock.save
	dynamic_reroute
	web_lock.in_use = false
	web_lock.save


	#when unsolved locations are more than minLocationNum and less than maxLocationNum, we distribute the passengers evenly to each bus
	sum_locs = 0
	WebBus.find(:all).each do |web_bus|
		sum_locs = sum_locs + web_bus.web_locations.count
	end
	if (WebLocation.find(:all).count - sum_locs) < $maxLocationNum && (WebLocation.find(:all).count - sum_locs) >= $minLocationNum 
		puts "double!"
		web_lock = WebLock.find_by_resource("web_location")
		web_lock.in_use = true
		web_lock.save
		distribute
		web_lock.in_use = false
		web_lock.save
	end


	#when a bus goes to idle, it should help pickup other buses' quest first, then go for new passengers submitted from web
	web_lock = WebLock.find_by_resource("web_location")
	web_lock.in_use = true
	web_lock.save
	WebBus.find(:all).each do |web_bus|
		if web_bus.web_locations.length == 1 
			#this is the idle bus
			shortest_dis = (2**(0.size * 8 -2)-1) #system max
			next_passenger = 0
			WebBus.find(:all).each do |web_bus_i|
				if web_bus_i.web_passengers.count > $reqHelpNum
					#this is statstic of bus queues
					passenger_locs = web_bus_i.web_locations.find(:all, :conditions => {:is_pickup => true})	
					passenger_locs.each do |passenger_loc|
						if shortest_dis > find_dis(passenger_loc, web_bus.web_locations.find(:first, :conditions => {:is_current => true}))
							shortest_dis = find_dis(passenger_loc, web_bus.web_locations.find(:first, :conditions => {:is_current => true}))
							next_passenger = passenger_loc.web_passenger
						end
					end
				end
			end
			
			if next_passenger != 0
				puts "execute helping process"

				#clean up the routing locations and remove the order_num for pick/drop points
				next_passenger.web_bus.web_locations.each do |web_loc|
					if web_loc.is_dropdown == false && web_loc.is_pickup == false && web_loc.is_current == false
						web_loc.destroy
					end
				end

				#assign the idle bus to next_passenger
				req_web_bus = next_passenger.web_bus
				next_passenger.web_locations.each do |loc|
					loc.web_bus = web_bus
					loc.order_num = nil
					loc.save
				end
				next_passenger.web_bus = web_bus
				next_passenger.save

				#re-build the route points for the bus that is requesting help
				prev_web_loc = req_web_bus.web_locations.find(:first, :conditions => {:is_current => true})
				web_locs = req_web_bus.web_locations.find(:all, :order => "order_num ASC")
				web_locs.each do |web_loc|
					web_loc.order_num = nil unless web_loc.is_current
					web_loc.save
				end
				web_locs.each do |web_loc|
					next unless web_loc.order_num == nil 
					next if web_loc.is_current
					generate_route_db(prev_web_loc.latitude, prev_web_loc.longitude, web_loc.latitude, web_loc.longitude, req_web_bus.id, web_loc.web_passenger.id, req_web_bus.web_locations.maximum(:order_num))
					web_loc.order_num = req_web_bus.web_locations.maximum(:order_num) + $reroute_insertion_space_num   
					web_loc.save
					prev_web_loc = web_loc
				end

				#build the route points for the idle bus
				bus_loc = web_bus.web_locations.find(:first, :conditions => {:is_current => true})
				pick_loc = web_bus.web_locations.find(:first, :conditions => {:is_pickup => true})
				drop_loc = web_bus.web_locations.find(:first, :conditions => {:is_dropdown => true})
				generate_route_db(bus_loc.latitude, bus_loc.longitude, pick_loc.latitude, pick_loc.longitude, web_bus.id, pick_loc.web_passenger.id, web_bus.web_locations.maximum(:order_num))
				pick_loc.order_num = web_bus.web_locations.maximum(:order_num) + $reroute_insertion_space_num   
				pick_loc.save
				generate_route_db(pick_loc.latitude, pick_loc.longitude, drop_loc.latitude, drop_loc.longitude, web_bus.id, pick_loc.web_passenger.id, web_bus.web_locations.maximum(:order_num))
				drop_loc.order_num = web_bus.web_locations.maximum(:order_num) + $reroute_insertion_space_num   
				drop_loc.save
			end
		end
	end
	web_lock.in_use = false
	web_lock.save

	#when unsolved locations are less than min_locationsNum, but there is an idle bus, we give that bus all passengers
	shortest_dis = (2**(0.size * 8 -2)-1) #system max
	closest_bus = 0
	WebBus.find(:all).each do |web_bus|
		sum_locs = 0
		WebBus.find(:all).each do |web_bus|
			sum_locs = sum_locs + web_bus.web_locations.count
		end
		if web_bus.web_locations.length == 1 && (WebLocation.find(:all).count - sum_locs) > 0 && (WebLocation.find(:all).count - sum_locs) < $maxLocationNum 
			current_loc = web_bus.web_locations.find(:first, :conditions =>{:is_current => true})
			web_passengers = WebPassenger.all
			web_passengers.each do |webPassenger|
				unless webPassenger.web_bus == nil #cull out passengers that has been picked by a bus
					web_passengers = web_passengers - [webPassenger]
				end
			end
			web_passengers.each do |passenger| #gets all the unhandled locations from database
				loc_pick = passenger.web_locations.find(:first, :conditions => {:is_pickup => true})
				if shortest_dis > find_dis(current_loc, loc_pick)
					shortest_dis = find_dis(current_loc, loc_pick)
					closest_bus = web_bus
				end
			end

		end
	end
	if closest_bus != 0
		puts "single!"
		web_lock = WebLock.find_by_resource("web_location")
		web_lock.in_use = true
		web_lock.save
		distribute closest_bus.id 
		web_lock.in_use = false
		web_lock.save
	end


	sum_locs = 0
	WebBus.find(:all).each do |web_bus|
		sum_locs = sum_locs + web_bus.web_locations.count
	end
	if (WebLocation.find(:all).count - sum_locs) >= $maxLocationNum && (WebLocation.find(:all).count - sum_locs) > $minLocationNum 
		puts "excessed service capbility...deleting extra passengers"
		while (WebLocation.find(:all).count - sum_locs) >= $maxLocationNum
			WebPassenger.last.web_locations.each do |web_loc|
				web_loc.destroy
			end
			WebPassenger.last.destroy
		end
	end
end


