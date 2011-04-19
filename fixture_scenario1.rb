=begin
this is the fixture that cleans up all passenger and quests, leaving only two bus at downtown
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

WebLock.delete_all

web_lock = WebLock.new
web_lock.resource = "web_location"
web_lock.in_use = false
web_lock.save

web_lock = WebLock.new
web_lock.resource = "web_passenger"
web_lock.in_use = false
web_lock.save

web_lock = WebLock.new
web_lock.resource = "web_bus"
web_lock.in_use = false
web_lock.save

WebLocation.delete_all

web_location = WebLocation.new
  web_location.id = 1
  web_location.web_bus_id = 1
  web_location.latitude = 50.4488
  web_location.longitude = -104.615
  web_location.is_current = true
  web_location.is_end = false
  web_location.is_pickup = false
  web_location.is_dropdown = false
  web_location.web_passenger_id = nil
  web_location.order_num = 1
web_location.save

web_location = WebLocation.new
  web_location.id = 2
  web_location.web_bus_id = 2
  web_location.latitude = 50.446
  web_location.longitude = -104.615
  web_location.is_current = true
  web_location.is_end = true
  web_location.is_pickup = false
  web_location.is_dropdown = false
  web_location.web_passenger_id = nil
  web_location.order_num = 1
web_location.save

WebPassenger.delete_all

WebBus.delete_all

web_bus = WebBus.new
  web_bus.id = 1
  web_bus.capacity = 5
web_bus.save

web_bus = WebBus.new
  web_bus.id = 2
  web_bus.capacity = 5
web_bus.save
