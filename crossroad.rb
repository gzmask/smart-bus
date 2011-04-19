
class Crossroad

	def initialize(latitude=nil, longitude=nil)
	if longitude == nil
	@longitude = 0.00
	else
	@longitude = longitude
	end
	if latitude == nil
	@latitude = 0.00
	else
	@latitude = latitude
	end
	end

	def longitude
	@longitude
	end

	def latitude
	@latitude
	end

	def location(latitude, longitude)
	@longitude = longitude
	@latitude = latitude
	end

  def to_s()
    String.new('Position(X:'+@latitude.to_s+', Y:'+@longitude.to_s+')')
  end
  

end
