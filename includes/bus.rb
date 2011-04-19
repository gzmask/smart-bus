# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'includes/location.rb'
class Bus
	def initialize(cur_location=nil, path_locations=[])
		@cur_location = cur_location
		@path_locations = path_locations
	end

	def set_cur_location(new_loc)
		@cur_location = new_loc
	end

	def cur_location()
		@cur_location
	end

	def path_locations()
		@path_locations
	end

	def add_path_locations(path_locations=[])
		@path_locations = @path_locations + path_locations
	end

	def remove_path_locations(path_locations=[])
		@path_locations = @path_locations - path_locations
	end

	def end_location()
		if @path_locations.empty?
			@cur_location
		else
			@path_locations.last
		end
	end

end
