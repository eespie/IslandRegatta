extends Sprite2D

var boat : Boat

enum ACTION {IDLE, ROTATING, TRANSLATING}
var action : ACTION = ACTION.IDLE

@export var epsilon : float = 0.01

var rotation_speed : float
var target_rotation : float

var linear_speed : float
var current_linear_speed : float = 0.0
var linear_inertia : float
var delta_position : Vector2
var target_position : Vector2
var last_ditance_to_target : float

var action_time : float

func rotate_boat(direction : float, rot_speed : float):
	action = ACTION.ROTATING
	target_rotation = 30.0 + 60.0 * direction
	var delta_rotation : float = target_rotation - rotation_degrees
	last_ditance_to_target = abs(delta_rotation)
	rotation_speed = sign(delta_rotation) * rot_speed
	action_time = delta_rotation / rot_speed
	if last_ditance_to_target > epsilon:
		current_linear_speed = 0
	else:
		action = ACTION.IDLE
		rotation_degrees = target_rotation
		boat.change_state()


func _rotating(delta : float):
	var rot_increment : float = rotation_speed * delta
	rotation_degrees += rot_increment
	var dist_to_target : float = abs(target_rotation - rotation_degrees)
	if dist_to_target > last_ditance_to_target:
		# overshoot
		action = ACTION.IDLE
		rotation_degrees = target_rotation
		boat.change_state()
	else:
		last_ditance_to_target = dist_to_target


func translate_boat(speed : float, dist : float, inertia : float):
	action = ACTION.TRANSLATING
	linear_speed = speed
	linear_inertia = inertia
	delta_position = Vector2.UP.rotated(get_rotation())
	target_position = position + delta_position * dist
	last_ditance_to_target = dist * dist


func _translating(delta):
	current_linear_speed = lerp(current_linear_speed, linear_speed, (1.0 - linear_inertia) * delta)
	boat.current_linear_speed = current_linear_speed
	var dp = delta_position * current_linear_speed * delta
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


func _process(delta):
	match action:
		ACTION.ROTATING:
			_rotating(delta)
		ACTION.TRANSLATING:
			_translating(delta)
