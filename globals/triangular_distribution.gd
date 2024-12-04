extends Node

@onready
var rng = RandomNumberGenerator.new()


func get_value(minimum: float, peak: float, maximum: float):
	var v: float = rng.randf()
	if v < (maximum - peak) / (maximum - minimum):
		v = minimum + sqrt(v * (maximum - minimum) * (peak - minimum))
	else:
		v = maximum - sqrt((1.0 - v) * (maximum - minimum) * (maximum - peak))
	
	return v
