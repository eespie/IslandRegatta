extends Node2D

var boat : Boat

enum ACTION {IDLE, ROTATING, TRANSLATING}
var action : ACTION = ACTION.IDLE

@export var epsilon : float = 0.01

@onready var boat_icon = %BoatIcon

var linear_speed : float

var linear_inertia : float
var delta_position : Vector2
var target_position : Vector2
var last_ditance_to_target : float

func rotate_boat(direction : float, rot_speed : float):
	action = ACTION.ROTATING
	boat_icon.rotate_boat(direction, rot_speed)


func _rotating(delta : float):
	boat_icon._rotating(delta)


func translate_boat(speed : float, dist : float, inertia : float):
	action = ACTION.TRANSLATING
	linear_speed = speed
	linear_inertia = inertia
	delta_position = Vector2.UP.rotated(boat_icon.get_rotation())
	target_position = position + delta_position * dist
	last_ditance_to_target = dist * dist


func _translating(delta):
	boat.set_linear_speed(lerp(boat.current_linear_speed, linear_speed, (1.0 - linear_inertia) * delta))
	var dp = delta_position * boat.current_linear_speed * delta
	position += dp
	var dist_to_target : float = target_position.distance_squared_to(position)
	if dist_to_target > last_ditance_to_target:
		# overshoot
		position = target_position
		action = ACTION.IDLE
		boat.change_state()
	else:
		last_ditance_to_target = dist_to_target


func recenter():
	set_position(Vector2.ZERO)


func set_action(act : ACTION):
	action = act


func _process(delta):
	match action:
		ACTION.ROTATING:
			_rotating(delta)
		ACTION.TRANSLATING:
			_translating(delta)
