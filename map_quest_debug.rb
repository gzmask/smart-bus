require 'net/http'
require 'rexml/document'
require 'includes/bus.rb'
require 'includes/passenger.rb'
require 'includes/location.rb'
require 'includes/db.rb'
require 'SmartBusWeb/app/models/web_bus.rb'
require 'SmartBusWeb/app/models/web_passenger.rb'
require 'SmartBusWeb/app/models/web_location.rb'

	lat_src = 50.4833521486671
	lng_src = -104.563807215761
	lat_des = 50.4388666989656 
	lng_des = -104.582462310791 
	web_bus_id = 1
	order_num = 1
	from_location = lat_src.to_s + ',' + lng_src.to_s #'50.4499078,-104.616708755'
	to_location = lat_des.to_s + ',' + lng_des.to_s #'50.40260948596879,-104.62546348571777'
	key = 'mjtd|lu61200tn9%2Crg%3Do5-50y25'
	server = 'platform.beta.mapquest.com'
	url = '/directions/v1/route?from='+ from_location + '&to=' + to_location + '&format=xml&key=' + key
	puts url
	xml_data = Net::HTTP.get_response(server, url).body

	xml = REXML::Document.new(xml_data)
	puts "root element: #{xml.root.name}"
	root = xml.root
	puts root.elements["route/legs/leg/maneuvers/maneuver/startPoint[2]"]


	root.elements.each("route/legs/leg/maneuvers/maneuver") do |maneuver| 
		next if maneuver.elements["startPoint/lat[1]"] == nil || maneuver.elements["startPoint/lng[1]"] == nil
		latitude = maneuver.elements["startPoint/lat[1]"].text.to_f 
		longitude = maneuver.elements["startPoint/lng[1]"].text.to_f 
		order_num = order_num + $reroute_insertion_space_num
		web_location = WebLocation.new
		web_location.latitude = latitude
		web_location.longitude = longitude
		web_location.is_current = false
		web_location.is_end = false
		web_location.is_pickup = false
		web_location.is_dropdown = false
		web_location.web_bus = WebBus.find(web_bus_id)
		web_location.order_num = order_num
		web_location.save
	end
