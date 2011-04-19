# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'includes/location.rb'
class Passenger
	def initialize (pick_location = nil, drop_location = nil)
		@PickLocation = pick_location
		@DropLocation = drop_location
	end

	def set_pick_location(new_location)
		@PickLocation = new_location
	end

	def pick_location
		@PickLocation
	end

  
	def set_drop_location(new_location)
		@DropLocation = new_location
	end

	def drop_location
		@DropLocation
	end

	def time_stamp=(new_time)
		@time_stamp = new_time
	end

end
