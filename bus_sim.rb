require 'includes/normalize.rb'
require 'matrix'
require 'includes/bus.rb'
require 'includes/passenger.rb'
require 'includes/location.rb'
require 'includes/db.rb'
require 'SmartBusWeb/app/models/web_bus.rb'
require 'SmartBusWeb/app/models/web_passenger.rb'
require 'SmartBusWeb/app/models/web_location.rb'
require 'SmartBusWeb/app/models/web_lock.rb'

#$sim_bus_speed stores the speed for the bus

while true
	sleep 1
	while true
		web_lock = WebLock.find_by_resource("web_location")
		break if web_lock.in_use == false
		sleep 0.5 
	end
	web_buses = WebBus.all
	web_pathes = Array.new
	web_buses.each do |web_bus|
		web_pathes << web_bus.web_locations.sort_by {|a| a.order_num }
	end
		
	web_pathes.each do |web_locs|
		#we advance web_locs[0] one step towards web_locs[1] until it reaches it, and then pop out web_locs[1] 
		next if web_locs[1] == nil
=begin
		puts web_locs[1].longitude
		a_debug = Vector[web_locs[1].longitude,web_locs[1].latitude]
		b_debug = Vector[web_locs[0].longitude,web_locs[0].latitude]
		c_debug = a_debug - b_debug
		puts c_debug.class
		d_debug = normalize(c_debug)
		puts d_debug.class
		puts $sim_bus_speed.class
		inc_speed = d_debug * $sim_bus_speed
=end
		inc_speed = normalize(Vector[web_locs[1].longitude, web_locs[1].latitude] - Vector[web_locs[0].longitude, web_locs[0].latitude]) * $sim_bus_speed 
		web_locs[0].longitude = web_locs[0].longitude + inc_speed[0] 
		web_locs[0].latitude = web_locs[0].latitude + inc_speed[1] 
		while true
			web_lock = WebLock.find_by_resource("web_location")
			break if web_lock.in_use == false
			sleep 0.5 
		end
		web_locs[0].save 
		if (web_locs[1] != nil && 
		(Vector[web_locs[1].longitude, web_locs[1].latitude] - Vector[web_locs[0].longitude, web_locs[0].latitude])[0].abs < (normalize(Vector[1,1]) * $sim_bus_speed)[0] && 
		(Vector[web_locs[1].longitude, web_locs[1].latitude] - Vector[web_locs[0].longitude, web_locs[0].latitude])[1].abs < (normalize(Vector[1,1]) * $sim_bus_speed)[1]) 
			web_pas = web_locs[1].web_passenger
			web_pas.destroy if web_locs[1].is_dropdown  
			while true
				web_lock = WebLock.find_by_resource("web_location")
				break if web_lock.in_use == false
				sleep 0.5 
			end
			web_locs[1].destroy
			web_locs.delete(web_locs[1])
		end
	end

end
