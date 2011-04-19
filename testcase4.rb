require 'location_distributor.rb'
require 'includes/bus.rb'
require 'includes/passenger.rb'

testtime = Time.now
demo = LocationDistributor.new
p1 = Passenger.new(Location.new(2,4), Location.new(2, 7))
p2 = Passenger.new(Location.new(9,1), Location.new(3, 3))
p3 = Passenger.new(Location.new(3,1), Location.new(5, 4))
p4 = Passenger.new(Location.new(7,10), Location.new(2, 2))
p5 = Passenger.new(Location.new(6,5), Location.new(2, 9))
p6 = Passenger.new(Location.new(6,6), Location.new(10, 10))
p7 = Passenger.new(Location.new(7,7), Location.new(11, 11))
p8 = Passenger.new(Location.new(6,8), Location.new(0, 0))
p9 = Passenger.new(Location.new(9,3), Location.new(5, 7))
p10 = Passenger.new(Location.new(4,7), Location.new(7, 4))
p11 = Passenger.new(Location.new(7,6), Location.new(5, 1))
p12 = Passenger.new(Location.new(3,2), Location.new(3, 3))
p13 = Passenger.new(Location.new(8,7), Location.new(6, 3))
p14 = Passenger.new(Location.new(2,3), Location.new(1, 5))
p15 = Passenger.new(Location.new(6,7), Location.new(2, 2))
p16 = Passenger.new(Location.new(3,1), Location.new(7, 9))
p17 = Passenger.new(Location.new(7,4), Location.new(4, 6))
p18 = Passenger.new(Location.new(1,3), Location.new(2, 6))
p19 = Passenger.new(Location.new(9,5), Location.new(8, 3))
b1 = Bus.new(Location.new(9,5))
b2 = Bus.new(Location.new(4,4))
b3 = Bus.new(Location.new(5,8))
b4 = Bus.new(Location.new(6,8))
b5 = Bus.new(Location.new(7,8))
b6 = Bus.new(Location.new(8,8))
#========================here shows how to add or remove buses and passengers==========================
demo.add_bus([b1, b2, b3, b4, b5, b6])
demo.remove_bus([b4, b5, b6])
demo.add_passengers([p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14])
demo.remove_passengers([p10,p11,p12,p13,p14])
#========================here shows how to call the distribution algorithm=============================
demo.bus_distribution
#========================here the result if being save in the result set and in the buses==============
demo.save_distribution
#========================here shows how to go through the result set===================================
demo.result_distribution.each do |path|
	path.each {|location| print "[" + location.latitude.to_s + "," + location.longitude.to_s + "]"}
	puts ""
end
puts ""
#========================here shows the path_locations are saved back into the buses===================
b1.path_locations.each {|location| print "[" + location.latitude.to_s + "," + location.longitude.to_s + "]"}
puts ""
b2.path_locations.each {|location| print "[" + location.latitude.to_s + "," + location.longitude.to_s + "]"}
puts ""
b3.path_locations.each {|location| print "[" + location.latitude.to_s + "," + location.longitude.to_s + "]"}
puts ""
#========================here we adds some more passengers when the buses are running with passengers already
demo.add_passengers([p10, p11, p12, p13, p14, p15, p16, p17, p18])
#====and now do the thing again===
demo.bus_distribution
demo.save_distribution
demo.result_distribution.each do |path|
	path.each {|location| print "[" + location.latitude.to_s + "," + location.longitude.to_s + "]"}
	puts ""
end
b1.path_locations.each {|location| print "[" + location.latitude.to_s + "," + location.longitude.to_s + "]"}
puts ""
b2.path_locations.each {|location| print "[" + location.latitude.to_s + "," + location.longitude.to_s + "]"}
puts ""
b3.path_locations.each {|location| print "[" + location.latitude.to_s + "," + location.longitude.to_s + "]"}
puts ""
#==========================================================
testtimeend = Time.new
resulttime = testtimeend - testtime
puts "Total searching time: " + resulttime.to_s + " seconds "

