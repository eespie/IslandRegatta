extends Node

@export_category('Synoptic wind')
@export_range(0, 360) var synoptic_wind_dir : int = 0
@export_range(4, 35) var synoptic_wind_speed : int = 20

@onready var map = %Map


func get_wind(pos : Vector2) -> Vector2i:
	return Vector2i(synoptic_wind_dir, synoptic_wind_speed)
