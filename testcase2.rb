require 'location_distributor.rb'
require 'bus.rb'
require 'passenger.rb'

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
p14 = Passenger.new(Location.new(2,5), Location.new(1, 5))
b1 = Bus.new(Location.new(9,5))
b2 = Bus.new(Location.new(4,4))
b3 = Bus.new(Location.new(5,8))
b4 = Bus.new(Location.new(6,8))
b5 = Bus.new(Location.new(7,8))
b6 = Bus.new(Location.new(8,8))
demo.add_bus([b1, b2, b3, b4, b5, b6])
demo.remove_bus([b4, b5, b6])
demo.add_passengers([p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14])
demo.remove_passengers([p10,p11,p12,p13,p14])
demo.bus_distribution
demo.result_distribution.each do |path|
	path.each {|location| print "[" + location.latitude.to_s + "," + location.longitude.to_s + "]"}
	puts ""
end
testtimeend = Time.new
resulttime = testtimeend - testtime
puts "Total searching time: " + resulttime.to_s + " seconds "

