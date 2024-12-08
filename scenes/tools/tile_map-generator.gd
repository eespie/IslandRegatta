@tool
extends Node

@export var water_color : String
@export var sand_color : String
@export var grass_color : String
@export var dirt_color : String

@onready var terrain = %Terrain

var tile_map : TileMapLayer
@export var is_generated : bool = false

func _process(_delta):
	if is_generated:
		return
	
	tile_map = get_parent()
	tile_map.clear()
	
	var width : int = terrain.size.x
	var height : int = terrain.size.y
	var image : Image = terrain.get_texture().get_image()
	var y : int = 0
	var x : int = 0
	
	while y < height:
		while x < width:
			var color : Color = image.get_pixel(x, y)
			match color.to_html():
				water_color:
					tile_map.set_cell(Vector2i(x,y), 0, Vector2i(0,0))
				sand_color:
					tile_map.set_cell(Vector2i(x,y), 0, Vector2i(1,0))
				grass_color:
					tile_map.set_cell(Vector2i(x,y), 0, Vector2i(2,0))
				dirt_color:
					tile_map.set_cell(Vector2i(x,y), 0, Vector2i(3,0))
				_:
					print(color.to_html())
			x += 1
		y += 1
		x = 0		

	is_generated = true
