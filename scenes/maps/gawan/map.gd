extends Map

@onready var terrain = %Terrain

@export var map_name : String

func recenter(current_pos : Vector2) -> Vector2:
	var terrain_pos : Vector2 = terrain.local_to_map(current_pos)
	return terrain.map_to_local(terrain_pos)
