extends Map

@onready var terrain = %Terrain
@onready var limits = %Limits
@onready var marks = %Marks

@export var map_name : String

func recenter(current_pos : Vector2) -> Vector2:
	return get_pos_from_tile(get_tile_pos(current_pos))

func get_tile_pos(pos : Vector2) -> Vector2:
	return terrain.local_to_map(pos)

func get_pos_from_tile(tile_pos : Vector2) -> Vector2:
	return terrain.map_to_local(tile_pos)

func is_free_water(tile_pos : Vector2) -> bool:
	var data = terrain.get_cell_tile_data(tile_pos)
	if data and data.get_custom_data("is_free"): # water
		data = limits.get_cell_tile_data(tile_pos)
		if data and not data.get_custom_data("is_free"): # limit
			return false
		data = marks.get_cell_tile_data(tile_pos)
		if data and not data.get_custom_data("is_free"): # a boat or a buoy
			return false
		return true
	
	return false
