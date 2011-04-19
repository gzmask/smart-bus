require 'location_distributor.rb'
require 'includes/bus.rb'
require 'includes/passenger.rb'
require 'includes/location.rb'
require 'includes/db.rb'
require 'SmartBusWeb/app/models/web_bus.rb'
require 'SmartBusWeb/app/models/web_passenger.rb'
require 'SmartBusWeb/app/models/web_location.rb'

#=================Dynamic Re-routing=============================

#1.Find out the unhandled passengers whose sources and destinations is close to one bus routine and has the same direction.
# assign them into the routine and this adds no cost at all.

#2.Find out the unhandled passengers whose source is close to bus routines.
# assign the sources to the routines, and add the destinations to the end locations for according buses. This adds N/2 costs.

#3.The rest of the unhandled passengers are those sources are not close to any bus routines.
# and these should be handled using normal routine. This adds N costs.

#================================================================
def dynamic_reroute

	#get all passengers
	passengers = Array.new
	web_passengers = WebPassenger.all

	#cull out passengers that has been picked by a bus
	web_passengers.each do |webPassenger|
		unless webPassenger.web_bus == nil 
			web_passengers = web_passengers - [webPassenger]
		end
	end

	#gets all the unhandled locations from database
	web_passengers.each do |passenger| 
		unless passenger.web_locations[0] == nil || passenger.web_locations[1] == nil
			loc_pick = passenger.web_locations.find(:first, :conditions => {:is_pickup => true})
			loc_drop = passenger.web_locations.find(:first, :conditions => {:is_dropdown => true})
=begin
			if passenger.web_locations[0].is_pickup
				loc_pick = Location.new( passenger.web_locations[0].latitude, passenger.web_locations[0].longitude )
				loc_drop = Location.new( passenger.web_locations[1].latitude, passenger.web_locations[1].longitude )
			else
				loc_pick = Location.new( passenger.web_locations[1].latitude, passenger.web_locations[1].longitude )
				loc_drop = Location.new( passenger.web_locations[0].latitude, passenger.web_locations[0].longitude )
			end
=end
			passengers << Passenger.new( loc_pick, loc_drop )
		end
	end

	#gets all the locations from bus paths and store them into web_pathes
	web_pathes = Array.new
	web_buses = WebBus.all
	web_buses.each do |web_bus|
		web_locs = web_bus.web_locations.sort_by {|a| a.order_num }
		web_pathes << web_locs
	end

	passengers.each do |passenger|
		web_pathes.each do |web_path|
			temp_var1 = 0
			temp_order1 = 0
			temp_var2 = 0
			temp_order2 = 0
			for i in 1...(web_path.length)
				if temp_var1 == 0 || temp_var1 == -1
				temp_var1 = intersection_chk(web_path[i-1].longitude, web_path[i-1].latitude, web_path[i].longitude, web_path[i].latitude, passenger.pick_location.longitude, passenger.pick_location.latitude, $distance_justification_num)
				temp_inc1 = temp_var1 / intersection_chk(web_path[i-1].longitude, web_path[i-1].latitude, web_path[i].longitude, web_path[i].latitude, web_path[i].longitude, web_path[i].latitude, $distance_justification_num)
				temp_inc1 = temp_inc1 * (web_path[i].order_num - web_path[i-1].order_num) #deBUG segment interval not always equal to reroute_insertion_space_num 
				temp_order1 = web_path[i-1].order_num
				end
				if temp_var2 == 0 || temp_var2 == -1
				temp_var2 = intersection_chk(web_path[i-1].longitude, web_path[i-1].latitude, web_path[i].longitude, web_path[i].latitude, passenger.drop_location.longitude, passenger.drop_location.latitude, $distance_justification_num)
				temp_inc2 = temp_var2 / intersection_chk(web_path[i-1].longitude, web_path[i-1].latitude, web_path[i].longitude, web_path[i].latitude, web_path[i].longitude, web_path[i].latitude, $distance_justification_num)
				temp_inc2 = temp_inc2 * (web_path[i].order_num - web_path[i-1].order_num)
				temp_order2 = web_path[i-1].order_num
				end
			end
			if (temp_var2 > temp_var1) && (temp_var1 > 0) && temp_order1 == temp_order2 #pick and drop in the same segment
				#case 1
				pick_loc = WebLocation.find(:first, :conditions => ["latitude = ? and longitude = ?", passenger.pick_location.latitude, passenger.pick_location.longitude])
				drop_loc = WebLocation.find(:first, :conditions => ["latitude = ? and longitude = ?", passenger.drop_location.latitude, passenger.drop_location.longitude])
				web_pas = pick_loc.web_passenger
				#use temp_order1 + 1 as the pick_location's order_num
				pick_loc.order_num = temp_order1 + temp_inc1
				#use temp_order2 + 2 as the drop_location's order_num
				drop_loc.order_num = temp_order2 + temp_inc2 
				#assign the current bus as pick/drop location's web bus
				pick_loc.web_bus = web_path[0].web_bus
				drop_loc.web_bus = web_path[0].web_bus
				web_pas.web_bus = web_path[0].web_bus
				if capacity_chk(pick_loc.web_bus) 
					pick_loc.save
					drop_loc.save
					web_pas.save
				end
			elsif (temp_var1 > 0) && (temp_var2 > 0) && temp_order2 > temp_order1 #pick and drop in different segments
				#case 1
				pick_loc = WebLocation.find(:first, :conditions => ["latitude = ? and longitude = ?", passenger.pick_location.latitude, passenger.pick_location.longitude])
				drop_loc = WebLocation.find(:first, :conditions => ["latitude = ? and longitude = ?", passenger.drop_location.latitude, passenger.drop_location.longitude])
				web_pas = pick_loc.web_passenger
				#use temp_order1 + 1 as the pick_location's order_num
				pick_loc.order_num = temp_order1 + temp_inc1
				#use temp_order2 + 1 as the pick_location's order_num
				drop_loc.order_num = temp_order2 + temp_inc2
				#assign the current bus as pick/drop location's web bus
				pick_loc.web_bus = web_path[0].web_bus
				drop_loc.web_bus = web_path[0].web_bus
				web_pas.web_bus = web_path[0].web_bus
				if capacity_chk(pick_loc.web_bus) 
					pick_loc.save
					drop_loc.save
					web_pas.save
				end
			elsif (temp_var1 > 0)
				#case 2
			elsif (temp_var1 == -1)
				#case 3
			end
		end
	end
end

#checks if the bus routine is validated for its capacity if pick up one more passenger
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


#inputs two bus routine points (x1,y1), (x2,y2), and passenger location (center_x, center_y) and the distance justification (radius), 
#returns the distance to (x1,y1) if the bus is close to this passenger 
#returns -1 if it's not close
def intersection_chk (x1, y1, x2, y2, center_x, center_y, radius)

	#check if the circle is in the bounding box rounded by sw_x, sw_y, ne_x, ne_y (southwest point and northeast point)
	if x1 < x2
		sw_x = x1
		ne_x = x2
	else
		sw_x = x2
		ne_x = x1
	end

	if y1 < y2
		sw_y = y1
		ne_y = y2
	else
		sw_y = y2
		ne_y = y1
	end
	sw_x = sw_x - radius
	sw_y = sw_y - radius
	ne_x = ne_x + radius
	ne_y = ne_y + radius

	if center_x > ne_x || center_x < sw_x || center_y > ne_y || center_y < sw_y
		return -1
	end

	#offset the center to 0,0
	x1_ = x1 - center_x
	y1_ = y1 - center_y
	x2_ = x2 - center_x
	y2_ = y2 - center_y

	#check for intersection
	dx = x2_ - x1_
	dy = y2_ - y1_
	dr = Math.sqrt(dx*dx + dy*dy)
	d = x1_*y2_ - x2_*y1_
	result = radius*radius*dr*dr - (d*d)
	if result < 0
		return -1
	else
		return Math.sqrt(((center_x - x1)*(center_x - x1) + (center_y - y1)*(center_y - y1)).abs)
	end
end

