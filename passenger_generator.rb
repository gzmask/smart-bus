=begin
this is the fixture that randomly generates passengers around the city
=end
require 'location_distributor.rb'
require 'includes/bus.rb'
require 'includes/passenger.rb'
require 'includes/location.rb'
require 'includes/db.rb'
require 'SmartBusWeb/app/models/web_bus.rb'
require 'SmartBusWeb/app/models/web_passenger.rb'
require 'SmartBusWeb/app/models/web_location.rb'
require 'SmartBusWeb/app/models/web_lock.rb'

a = 1

puts "enter the passenger number you want to generate:"
a = gets.to_i

1.upto(a).each do |i|
	web_passenger = WebPassenger.new
	if WebPassenger.count == 0
		web_passenger.id = 1
	else
		web_passenger.id = WebPassenger.maximum(:id) + 1 
	end
	  web_passenger.password = 'random dots'
	  web_passenger.web_bus_id = nil
	web_passenger.save

	web_location = WebLocation.new
	  web_location.id = WebLocation.maximum(:id) + 1
	  web_location.web_bus_id = nil
	  web_location.latitude = 50.3962 + rand(878)/10000.to_f
	  web_location.longitude = -104.6636 + rand(1133)/10000.to_f
	  web_location.is_current = false
	  web_location.is_end = false
	  web_location.is_pickup = true
	  web_location.is_dropdown = false
	  web_location.web_passenger_id = web_passenger.id
	  web_location.order_num = nil
	web_location.save

	web_location = WebLocation.new
	  web_location.id = WebLocation.maximum(:id) + 1
	  web_location.web_bus_id = nil
	  web_location.latitude = 50.3962 + rand(878)/10000.to_f
	  web_location.longitude = -104.6636 + rand(1133)/10000.to_f
	  web_location.is_current = false
	  web_location.is_end = false
	  web_location.is_pickup = false
	  web_location.is_dropdown = true
	  web_location.web_passenger_id = web_passenger.id
	  web_location.order_num = nil
	web_location.save
end
