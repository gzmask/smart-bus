require 'net/http'
require 'rexml/document'
require 'includes/bus.rb'
require 'includes/passenger.rb'
require 'includes/location.rb'
require 'includes/db.rb'
require 'SmartBusWeb/app/models/web_bus.rb'
require 'SmartBusWeb/app/models/web_passenger.rb'
require 'SmartBusWeb/app/models/web_location.rb'

def generate_route_db (lat_src, lng_src, lat_des, lng_des, web_bus_id, web_passenger_id, order_num)
	if Math.sqrt(((lat_des - lat_src)*(lat_des - lat_src) - (lng_des - lng_src)*(lng_des - lng_src)).abs) < $skip_map_quest_distance
		return 0
	end
	from_location = lat_src.to_s + ',' + lng_src.to_s #'50.4499078,-104.616708755'
	to_location = lat_des.to_s + ',' + lng_des.to_s #'50.40260948596879,-104.62546348571777'
	key = 'mjtd|lu61200tn9%2Crg%3Do5-50y25'
	server = 'platform.beta.mapquest.com'
	url = '/directions/v1/route?from='+ from_location + '&to=' + to_location + '&format=xml&key=' + key
	puts url
	xml_data = Net::HTTP.get_response(server, url).body

	xml = REXML::Document.new(xml_data)
	#puts "root element: #{xml.root.name}"
	root = xml.root
	#puts root.elements["route/legs/leg/maneuvers/maneuver/startPoint[2]"]


	root.elements.each("route/legs/leg/maneuvers/maneuver") do |maneuver| 
		next if maneuver.elements["startPoint/lat[1]"] == nil || maneuver.elements["startPoint/lng[1]"] == nil
		latitude = maneuver.elements["startPoint/lat[1]"].text.to_f 
		longitude = maneuver.elements["startPoint/lng[1]"].text.to_f 
		order_num = order_num + $reroute_insertion_space_num
		while WebLocation.find(:first, :conditions => ["latitude = ? and longitude = ?", latitude, longitude]) != nil
			#randomized the location
			latitude = (latitude.to_s << rand(9).to_s).to_f
			longitude = (longitude.to_s << rand(9).to_s).to_f
		end
		web_location = WebLocation.new
		web_location.latitude = latitude
		web_location.longitude = longitude
		web_location.is_current = false
		web_location.is_end = false
		web_location.is_pickup = false
		web_location.is_dropdown = false
		web_location.web_bus = WebBus.find(web_bus_id)
		web_location.order_num = order_num
		puts "order_num: " + order_num.to_s
		web_location.save
	end
end
