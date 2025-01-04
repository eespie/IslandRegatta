extends Node2D

@onready var marker_2d_min = %Marker2DMin
@onready var marker_2d_max = %Marker2DMax
@onready var terrain = %Terrain

var wind : Wind

var tile_zone_min : Vector2
var tile_zone_max : Vector2

func _ready():
	tile_zone_min = get_tile_pos(marker_2d_min.position)
	tile_zone_max = get_tile_pos(marker_2d_max.position)


func get_tile_pos(pos : Vector2) -> Vector2:
	return terrain.local_to_map(pos)


func get_pos_from_tile(tile_pos : Vector2) -> Vector2:
	return terrain.map_to_local(tile_pos)


func _draw():
	draw_wind()


func draw_wind():
	for x in range(tile_zone_min.x, tile_zone_max.x):
		for y in range(tile_zone_min.y, tile_zone_max.y):
			var tile_pos := Vector2(x, y)
			var data = terrain.get_cell_tile_data(tile_pos)
			if data and data.get_custom_data("is_free"):
				var tile_global_pos := get_pos_from_tile(tile_pos)
				var wind_vector = wind.get_wind_vector(tile_global_pos)
				
				draw_line(tile_global_pos, tile_global_pos + wind_vector, Color.YELLOW, 2, true)
