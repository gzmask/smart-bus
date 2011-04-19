#this test case shows how to use 1 bus to take all the passengers
require 'location_distributor.rb'
require 'includes/bus.rb'
require 'includes/passenger.rb'

testtime = Time.now
demo = LocationDistributor.new
p1 = Passenger.new(Location.new(2,4), Location.new(2, 5))
p2 = Passenger.new(Location.new(9,1), Location.new(3, 3))
p3 = Passenger.new(Location.new(3,1), Location.new(5, 4))
p4 = Passenger.new(Location.new(7,10), Location.new(2, 2))
p5 = Passenger.new(Location.new(6,5), Location.new(2, 9))
p6 = Passenger.new(Location.new(6,6), Location.new(10, 10))
p7 = Passenger.new(Location.new(7,7), Location.new(11, 11))
demo.add_bus([Bus.new(Location.new(9,5))])
demo.add_passengers([p1,p2,p3,p4,p5])


demo.sort
demo.result_distribution.each do |locations|  
	locations.each do |stop|
		print "("
		print stop.latitude
		print ","
		print stop.longitude
		print ")"
	end
	puts "bus"
end
testtimeend = Time.new
resulttime = testtimeend - testtime
puts "Total searching time: " + resulttime.to_s + " seconds "

