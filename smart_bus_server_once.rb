require 'location_distributor.rb'
require 'includes/bus.rb'
require 'includes/passenger.rb'
require 'includes/location.rb'
require 'includes/db.rb'
require 'map_quest.rb'
require 'SmartBusWeb/app/models/web_bus.rb'
require 'SmartBusWeb/app/models/web_passenger.rb'
require 'SmartBusWeb/app/models/web_location.rb'

def distribute (bus_id = nil)
	cycle_time = Time.now

	#get all passengers
	array_passengers = Array.new
	web_passengers = WebPassenger.all
	web_passengers.each do |web_passenger|
		if web_passenger.web_locations.count < 2
			web_passengers = web_passengers - [web_passenger]
		end
	end
	WebBus.all.each do |web_bus|
		web_bus.web_passengers.each do |web_passenger|
			web_passengers = web_passengers - [web_passenger]
		end
	end
	puts web_passengers
	web_passengers.each do |passenger| #gets all the unhandled locations from database
		loc_pick = passenger.web_locations.find(:first, :conditions => {:is_pickup => true})
		loc_drop = passenger.web_locations.find(:first, :conditions => {:is_dropdown => true})
		array_passengers << Passenger.new( loc_pick, loc_drop )
	end

	if bus_id == nil
		#get all buses
		array_buses = Array.new
		#add the current routine to each bus
		web_buses = WebBus.all
		web_buses.each do |bus|
		    path_locs = Array.new
		    web_locs = bus.web_locations.sort_by {|a| a.order_num }
		    web_locs.each do |location|
		      loc = Location.new(location.latitude, location.longitude)
		      path_locs << loc
		    end
		    start_loc = path_locs[0]
		    path_locs = path_locs - [start_loc]
		    array_buses << Bus.new(start_loc, path_locs) #the bus is created with existed locations path
		end
	else
		#get bus_id bus
		array_buses = Array.new
		#add the current routine to each bus
		bus = WebBus.find(bus_id)
		path_locs = Array.new
		web_locs = bus.web_locations.sort_by {|a| a.order_num }
		web_locs.each do |location|
		loc = Location.new(location.latitude, location.longitude)
		path_locs << loc
		end
		start_loc = path_locs[0]
		path_locs = path_locs - [start_loc]
		array_buses << Bus.new(start_loc, path_locs)
	end


	path_finder = LocationDistributor.new
	#========================shows how to add or remove buses and passengers==========================
	puts array_buses
	puts array_passengers
	array_passengers.each do |passenger|
		puts "passenger: " + passenger.pick_location.to_s + passenger.drop_location.to_s
	end
	path_finder.add_bus(array_buses)
	path_finder.add_passengers(array_passengers)
	#========================shows how to call the distribution algorithm=============================
	path_finder.bus_distribution
	#========================the result being save in the array_buses==============
	path_finder.save_distribution
	#========================save the algorithm result into database===================

	
	if bus_id == nil
		#bus_id = 0
		web_buses = WebBus.all
		web_buses = web_buses.reverse
		array_buses.each do |bus|
		  #bus_id = bus_id + 1
			next if bus.path_locations.empty?
			#cur_web_bus = WebBus.find(bus_id)
			cur_web_bus = web_buses.pop
			prev_web_loc = cur_web_bus.web_locations.find(:all, :order => "order_num ASC").last
			bus.path_locations.each do |location|
				#bug here! doesn't allow duplicated locations, need another way to get locations or check duplications
				web_loc = WebLocation.find(:first, :conditions => ["latitude = ? and longitude = ?", location.latitude, location.longitude])
				next unless web_loc.order_num == nil #important! this statement skips all the existed locations path
				next if web_loc.is_current == true
				web_loc.web_bus = cur_web_bus
				web_loc.web_passenger.web_bus = cur_web_bus
				if capacity_chk(web_loc.web_bus) 
					#get route locations from map quest
					generate_route_db(prev_web_loc.latitude, prev_web_loc.longitude, web_loc.latitude, web_loc.longitude, cur_web_bus.id, web_loc.web_passenger.id, cur_web_bus.web_locations.maximum(:order_num))
					web_loc.order_num = cur_web_bus.web_locations.maximum(:order_num) + $reroute_insertion_space_num #the maximum function make sure routine points and drop/pick points won't mess   
					web_loc.save
					web_loc.web_passenger.save
					prev_web_loc = web_loc
				end
			end
		end
	else
		cur_web_bus = WebBus.find(bus_id)
		prev_web_loc = cur_web_bus.web_locations.find(:all, :order => "order_num ASC").last
		array_buses[0].path_locations.each do |location|
			#bug here! doesn't allow duplicated locations, need another way to get locations or check duplications
			web_loc = WebLocation.find(:first, :conditions => ["latitude = ? and longitude = ?", location.latitude, location.longitude])
			next unless web_loc.order_num == nil #important! this statement skips all the existed locations path
			next if web_loc.is_current == true
			web_loc.web_bus = cur_web_bus
			web_loc.web_passenger.web_bus = cur_web_bus
			if capacity_chk(web_loc.web_bus) 
				#get route locations from map quest
				generate_route_db(prev_web_loc.latitude, prev_web_loc.longitude, web_loc.latitude, web_loc.longitude, cur_web_bus.id, web_loc.web_passenger.id, cur_web_bus.web_locations.maximum(:order_num))
				web_loc.order_num = cur_web_bus.web_locations.maximum(:order_num) + $reroute_insertion_space_num   
				web_loc.save
				web_loc.web_passenger.save
				prev_web_loc = web_loc
			end
		end
	end

	cycle_time_end = Time.new
	cycle_time = cycle_time_end - cycle_time
	puts "cycle searching time: " + cycle_time.to_s + " seconds "

end

#checks if the bus routine is validated for its capacity
def capacity_chk (web_bus)
	web_locs = web_bus.web_locations.sort_by {|a| a.order_num }
	stackLen = 0
	web_locs.each do |web_loc|
		if web_loc.is_pickup
			stackLen = stackLen + 1
		else
			stackLen = stackLen - 1
		end
		if stackLen > web_bus.capacity
			return false
		end
	end
	return true
end

