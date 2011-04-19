require "matrix"

def normalize (vector2 = Vector[0,0])
	length = Math.sqrt(vector2[0]*vector2[0] + vector2[1]*vector2[1])
	return Vector[vector2[0]/length, vector2[1]/length]
end
