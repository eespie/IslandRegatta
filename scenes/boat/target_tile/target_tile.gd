extends Node2D

@onready var target_ok = %TargetOk
@onready var target_blocked = %TargetBlocked

var map : Map

var tile_pos : Vector2
var is_blocked : bool = false


func set_tile_pos(pos : Vector2):
	tile_pos = pos
	is_blocked = not map.is_free_water(pos)
	if is_blocked:
		target_ok.hide()
		target_blocked.show()
	else:
		target_ok.show()
		target_blocked.hide()
