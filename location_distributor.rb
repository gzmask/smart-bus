require 'includes/passenger.rb'
require 'includes/bus.rb'

class LocationDistributor

	public

	def initialize
		@passengers = Array.new
		@buses = Array.new
		@result_distribution = Array.new
		@permutation = []#temperated best cost path
		@passenger_permutations = []#temperate passenger permutation
	end

	def buses
		@buses
	end

	def result_distribution
		@result_distribution
	end

	def add_passengers(in_passengers=[])
		in_passengers.each {|passenger| @passengers.push(passenger)}
	end

	def remove_passengers(out_passengers=[])
		@passengers = @passengers - out_passengers
	end

	def add_bus(in_bus=[])
		in_bus.each {|bus| @buses.push(bus) }
	end

	def remove_bus(out_bus=[])
		@buses = @buses - out_bus
	end

	#saves the result_distribution to each bus and clears the passenger queue
	def save_distribution()		
		(0..(@buses.length-1)).each do |index|
			@buses[index].add_path_locations(@result_distribution[index]) if @result_distribution[index] != nil
		end
		@passengers = []
		@permutation = []
		@passenger_permutations = []
	end

	#distributes passengers to each bus and find out the cheapest distribution
	#the cheapest distribution is stored in the @result_distribution
	def bus_distribution (culling_cost=nil)
		if @passengers.length == 0
			#do nothing
		elsif @buses.length == 1 && @passengers.length > 0 
			sort
			@result_distribution = @array_pathes
			return
		else
			if @passengers.length % @buses.length == 0
				evenly_distributed_num = @passengers.length / @buses.length
			else
				evenly_distributed_num = @passengers.length / @buses.length + 1
			end
			processing_passengers = @passengers.dup
			passenger_permutation(processing_passengers)
			lowest_cost = (2**(0.size * 8 -2)-1) #system Max			
			@passenger_permutations.each do |array_passengers|
				array_paths = Array.new
				cost = 0
				#the reason of reverse: we want the new bus get the load
				@buses.reverse_each do |bus|
					next if cost > lowest_cost
					if (culling_cost != nil)
						@culling_cost = culling_cost
					else
						@culling_cost = (2**(0.size * 8 -2)-1) #system Max
					end
					array_locations = Array.new
					array_passengers[0...evenly_distributed_num].each do |passenger|
						if passenger != nil
							array_locations.push(passenger.pick_location)
							array_locations.push(passenger.drop_location)
						end
					end
					if !array_locations.empty?
						sort_bus(bus, array_locations)
						cost += @culling_cost
					end
					if bus.path_locations.length > 1						
						cost += find_cost(bus.cur_location, bus.path_locations, (1...bus.path_locations.length).to_a)						
					elsif bus.path_locations.length == 1	
						cost += 1
					end				
					array_passengers = array_passengers - array_passengers[0...evenly_distributed_num]
					array_paths << array_locations
				end
				if lowest_cost > cost
					lowest_cost = cost
					culling_cost = cost
					#since we add the array reversely
					@result_distribution = array_paths.reverse.dup
				else
					array_paths = [] #we only want the cheapest, this isn't, so clear out
				end
			end
		end
	end

	private

	#set culling_cost to be very large as auto_culling
	def sort(culling_cost=nil)
		@array_pathes = Array.new
		@buses.each do |bus|
			if (culling_cost != nil)
				@culling_cost = culling_cost
			else
				@culling_cost = (2**(0.size * 8 -2)-1) #system Max
			end
			array_locations = Array.new
			@passengers.each do |passenger|
				array_locations.push(passenger.pick_location)
				array_locations.push(passenger.drop_location)
			end
			lowest_cost_sort(bus.end_location ,array_locations) #find out the lowest cost routine for this bus for all passengers
			@array_pathes.push(array_locations)
		end
		@result_distribution = @array_pathes
	end


	#this function permutates the array it takes, and it's recursive
	#after excution, all possible permuation of passengers will be in @passenger_permutations
	def passenger_permutation (processing_passengers, sorted_passengers=[])
		processing_passengers.each do |passenger|
			if processing_passengers.length == 1 && segment_in_order(sorted_passengers + [passenger])
				@passenger_permutations << sorted_passengers + [passenger]
			else
				passenger_permutation(processing_passengers-[passenger], sorted_passengers+[passenger])
			end
		end
	end

	# returns whether the passengers are in smaller lexical order in each bus segments to make sure they are unique in segments
	def segment_in_order (passengers)
		if @passengers.length % @buses.length == 0
			segment_size = @passengers.length / @buses.length
			num_seg = @buses.length
		else
			segment_size = @passengers.length / @buses.length + 1
			num_seg = @buses.length
		end
		start_range = 1
		1.upto(num_seg) do |n|
			end_range = segment_size*n
			start_range.upto(end_range-1) do |index|
				index = index-1
				break if passengers[index+1] == nil
				if ([passengers[index].pick_location.latitude, passengers[index].pick_location.longitude] <=> [passengers[index+1].pick_location.latitude, passengers[index+1].pick_location.longitude]) == 1
					return false
				end
			end
			start_range = end_range + 1
		end
		return true
	end

	def permutation
		@permutation
	end

	def array_pathes
		@array_pathes
	end

	#this functions returns the cheapest path for bus_in and array_locations
	def sort_bus(bus_in=nil, array_locations=[])
		lowest_cost_sort(bus_in.end_location ,array_locations) #find out the lowest cost routine for this bus for all passengers
		return array_locations
	end

	#this function takes a start location, and random path, and returns the cheapest path with the provided start location
	def lowest_cost_sort(start_location, array_locations)
		temp_array = Array.new()
		1.upto(array_locations.length) do |index|
			temp_array.push(index)
		end
		generate_permutation([], temp_array, start_location, array_locations)
		array_locations2 = array_locations.dup
		loc_index = 0
		@permutation[0].each do |index|
			array_locations[loc_index] = array_locations2[index-1]
			loc_index = loc_index + 1
		end
		return array_locations
	end



	#this is the core of the whole thing... it's recursive
	#first parameter is an array of already cheapest path of location ID array
	#second parameter is an array of random location ID array
	#third parameter is the lastest location to travel the array_unsort
	#fourth parameter is the array that maps the IDs to actual locations in which there are latitudes and longitudes
	#the result is two cheapest paths for all possible paths, store in the @permutation instance variable. @permutation[0] being the cheapest and @permutation[1] being the 2nd cheapest
	def generate_permutation(array_sorted=[], array_unsort=[], start_location=nil, array_locations=[], level=0)
		if array_unsort.length > 1 && level == 0
			array_unsort.each do |element|
				temp_array = array_unsort- [element]
				generate_permutation([element], temp_array, start_location, array_locations, level+1)
			end
		elsif array_unsort.length > 1
			if (check_path(array_sorted) && find_cost(start_location, array_locations, array_sorted) < @culling_cost)
				array_unsort.each do |element|
					temp_array = array_unsort- [element]
					generate_permutation([element]+array_sorted, temp_array, start_location, array_locations, level+1)
				end
			end
		else
			#check if the array is validated and only puts the valid ones into @permutation, also cull out some large cost ones
			if (check_path(array_sorted + array_unsort) && find_cost(start_location, array_locations, array_sorted + array_unsort) < @culling_cost)
				@permutation[0] = (array_sorted + array_unsort)
				@culling_cost = find_cost(start_location, array_locations, array_sorted + array_unsort)
				#puts "Searching... Cost: " + @culling_cost.to_s + " Path: " + (array_sorted + array_unsort).to_s #<----------delete this if you dont want to see some actions
			elsif (check_path(array_sorted + array_unsort) && find_cost(start_location, array_locations, array_sorted + array_unsort) == @culling_cost)
				@permutation[1] = (array_sorted + array_unsort)
				@culling_cost = find_cost(start_location, array_locations, array_sorted + array_unsort)
				#puts "Searching duplicated Cost: " + @culling_cost.to_s + " Path: " + (array_sorted + array_unsort).to_s #<----------delete this if you dont want to see some actions
			end
		end
	end

	#the order array should be (1...array_locations.length).to_a if the array_location is not random
	def find_cost(start_location, array_locations, order_array)
		cost = (start_location.latitude - array_locations[order_array[0]-1].latitude).abs + (start_location.longitude - array_locations[order_array[0]-1].longitude).abs
		1.upto(order_array.length-1) do |index|
			cost = cost + ((array_locations[order_array[index]-1].latitude - array_locations[order_array[index-1]-1].latitude).abs + (array_locations[order_array[index]-1].longitude - array_locations[order_array[index-1]-1].longitude).abs)
		end
		return cost
	end

	def check_path(array_in)
		#for each odd number in this array
		0.upto(array_in.length-1) do |index|
			next if array_in[index] % 2 == 0
			if array_in[0...index].include?(array_in[index]+1)
				return false
			end
		end
		return true
	end



end
