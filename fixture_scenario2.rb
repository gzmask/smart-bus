=begin
this is the fixture that generate some passengers around the city with purposes
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

web_passenger = WebPassenger.new
  web_passenger.id = 1 
  web_passenger.password = 'sick guy'
  web_passenger.web_bus_id = nil
web_passenger.save

web_location = WebLocation.new
  web_location.id = 9
  web_location.web_bus_id = nil
  web_location.latitude = 50.45029
  web_location.longitude = -104.62512
  web_location.is_current = false
  web_location.is_end = false
  web_location.is_pickup = true
  web_location.is_dropdown = false
  web_location.web_passenger_id = 1
  web_location.order_num = nil
web_location.save

web_location = WebLocation.new
  web_location.id = 10
  web_location.web_bus_id = nil
  web_location.latitude = 50.44389
  web_location.longitude = -104.59911
  web_location.is_current = false
  web_location.is_end = false
  web_location.is_pickup = false
  web_location.is_dropdown = true
  web_location.web_passenger_id = 1
  web_location.order_num = nil
web_location.save


web_passenger = WebPassenger.new
  web_passenger.id = 2 
  web_passenger.password = 'southland mall'
  web_passenger.web_bus_id = nil
web_passenger.save

web_location = WebLocation.new
  web_location.id = 11
  web_location.web_bus_id = nil
  web_location.latitude = 50.44996
  web_location.longitude = -104.61421
  web_location.is_current = false
  web_location.is_end = false
  web_location.is_pickup = true
  web_location.is_dropdown = false
  web_location.web_passenger_id = 2
  web_location.order_num = nil
web_location.save

web_location = WebLocation.new
  web_location.id = 12
  web_location.web_bus_id = nil
  web_location.latitude = 50.40217
  web_location.longitude = -104.62177
  web_location.is_current = false
  web_location.is_end = false
  web_location.is_pickup = false
  web_location.is_dropdown = true
  web_location.web_passenger_id = 2
  web_location.order_num = nil
web_location.save

web_passenger = WebPassenger.new
  web_passenger.id = 3 
  web_passenger.password = 'buy house'
  web_passenger.web_bus_id = nil
web_passenger.save

web_location = WebLocation.new
  web_location.id = 13
  web_location.web_bus_id = nil
  web_location.latitude = 50.40102
  web_location.longitude = -104.62581
  web_location.is_current = false
  web_location.is_end = false
  web_location.is_pickup = true
  web_location.is_dropdown = false
  web_location.web_passenger_id = 3
  web_location.order_num = nil
web_location.save

web_location = WebLocation.new
  web_location.id = 14
  web_location.web_bus_id = nil
  web_location.latitude = 50.42181
  web_location.longitude = -104.54075
  web_location.is_current = false
  web_location.is_end = false
  web_location.is_pickup = false
  web_location.is_dropdown = true
  web_location.web_passenger_id = 3
  web_location.order_num = nil
web_location.save

web_passenger = WebPassenger.new
  web_passenger.id = 4 
  web_passenger.password = 'new student'
  web_passenger.web_bus_id = nil
web_passenger.save

web_location = WebLocation.new
  web_location.id = 15
  web_location.web_bus_id = nil
  web_location.latitude = 50.43394
  web_location.longitude = -104.65627
  web_location.is_current = false
  web_location.is_end = false
  web_location.is_pickup = true
  web_location.is_dropdown = false
  web_location.web_passenger_id = 4
  web_location.order_num = nil
web_location.save

web_location = WebLocation.new
  web_location.id = 16
  web_location.web_bus_id = nil
  web_location.latitude = 50.41568
  web_location.longitude = -104.59104
  web_location.is_current = false
  web_location.is_end = false
  web_location.is_pickup = false
  web_location.is_dropdown = true
  web_location.web_passenger_id = 4
  web_location.order_num = nil
web_location.save

web_passenger = WebPassenger.new
  web_passenger.id = 5 
  web_passenger.password = 'rainbow cheaper'
  web_passenger.web_bus_id = nil
web_passenger.save

web_location = WebLocation.new
  web_location.id = 17 
  web_location.web_bus_id = nil
  web_location.latitude = 50.48181
  web_location.longitude = -104.66743
  web_location.is_current = false
  web_location.is_end = false
  web_location.is_pickup = true
  web_location.is_dropdown = false
  web_location.web_passenger_id = 5
  web_location.order_num = nil
web_location.save

web_location = WebLocation.new
  web_location.id = 18
  web_location.web_bus_id = nil
  web_location.latitude = 50.41683
  web_location.longitude = -104.62125
  web_location.is_current = false
  web_location.is_end = false
  web_location.is_pickup = false
  web_location.is_dropdown = true
  web_location.web_passenger_id = 5
  web_location.order_num = nil
web_location.save

web_passenger = WebPassenger.new
  web_passenger.id = 6 
  web_passenger.password = 'rich friend'
  web_passenger.web_bus_id = nil
web_passenger.save

web_location = WebLocation.new
  web_location.id = 19
  web_location.web_bus_id = nil
  web_location.latitude = 50.40791
  web_location.longitude = -104.60967
  web_location.is_current = false
  web_location.is_end = false
  web_location.is_pickup = true
  web_location.is_dropdown = false
  web_location.web_passenger_id = 6
  web_location.order_num = nil
web_location.save

web_location = WebLocation.new
  web_location.id = 20
  web_location.web_bus_id = nil
  web_location.latitude = 50.42962
  web_location.longitude = -104.53165
  web_location.is_current = false
  web_location.is_end = false
  web_location.is_pickup = false
  web_location.is_dropdown = true
  web_location.web_passenger_id = 6
  web_location.order_num = nil
web_location.save

