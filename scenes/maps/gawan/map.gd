extends Map

@onready var terrain = %Terrain

@export var map_name : String

func recenter(current_pos : Vector2) -> Vector2:
	return get_pos_from_tile(get_tile_pos(current_pos))

func get_tile_pos(pos : Vector2) -> Vector2:
	return terrain.local_to_map(pos)

func get_pos_from_tile(tile_pos : Vector2) -> Vector2:
	return terrain.map_to_local(tile_pos)
