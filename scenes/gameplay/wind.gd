extends Wind

@export_category('Synoptic wind')
@export_range(0, 359) var synoptic_wind_dir : int = 0
@export_range(4, 35) var synoptic_wind_speed : int = 25

@export_category('Magic constant')
@export var coeff_sum : float = 20.0

var step_angle_deg : int = 15
var step_displacement : int = 120

var vec : Vector3

var map : Node2D

# dir from 0 to 359
func get_wind_dir(pos : Vector2) -> int:
	return -roundi(rad_to_deg(get_wind_vector(pos).angle_to(Vector2.DOWN)))

# speed in knots (1 to 35)
func get_wind_speed(pos : Vector2) -> int:
	return roundi(get_wind_vector(pos).length())

# true wind vector at position
func get_wind_vector(pos: Vector2) -> Vector2:
	var wind := polar_to_euclydian(synoptic_wind_dir + 180, synoptic_wind_speed)
	var step : int = 0
	var iterations : int = 0
	for angle_deg in range(-180, 180, step_angle_deg):
		var selector := absi(angle_deg - 30) % 60
		match selector:
			0:
				step = 120
				iterations = 3
			30:
				step = 240
				iterations = 2
			15, 45:
				step = 360
				iterations = 1
		
		var height_coeff : float = 0
		for dist in range(step, (iterations + 1) * step, step):
			var target := pos + polar_to_euclydian(angle_deg, dist)
			var height = map.get_height(target)
			height_coeff += height * (step_displacement / dist)
			
		height_coeff = height_coeff * synoptic_wind_speed / coeff_sum
		var twa_deg := synoptic_wind_dir - angle_deg
		if angle_deg < 0:
			twa_deg += 180
		var deviation_deg : float = synoptic_wind_dir + 180 + cos(deg_to_rad(twa_deg + 180)) * 180.0
		var deviation := polar_to_euclydian(deviation_deg, height_coeff)
		wind += deviation
	
	return wind
	
func normalize_rotation(rot : float) -> int:
	while rot > 180:
		rot -= 360
	while rot < -180:
		rot += 360
	return roundi(rot)

func polar_to_euclydian(dir_deg: float, len: float)-> Vector2:
	return Vector2.UP.rotated(deg_to_rad(dir_deg)) * len
