extends Sprite2D

@export var epsilon : float = 0.01

@onready var real_boat = %RealBoat

var boat

var rotation_speed : float
var target_rotation : float
var last_ditance_to_target : float

func _ready():
	set_rotation_degrees(30)

func rotate_boat(direction : float, rot_speed : float):
	target_rotation = 30.0 + 60.0 * direction
	var delta_rotation : float = target_rotation - rotation_degrees
	last_ditance_to_target = abs(delta_rotation)
	rotation_speed = sign(delta_rotation) * rot_speed
	if last_ditance_to_target > epsilon:
		real_boat.stop_boat()
	else:
		real_boat.set_action(real_boat.ACTION.IDLE)
		rotation_degrees = target_rotation
		boat.change_state()


func _rotating(delta : float):
	var rot_increment : float = rotation_speed * delta
	rotation_degrees += rot_increment
	var dist_to_target : float = abs(target_rotation - rotation_degrees)
	if dist_to_target > last_ditance_to_target:
		# overshoot
		real_boat.set_action(real_boat.ACTION.IDLE)
		rotation_degrees = target_rotation
		boat.change_state()
	else:
		last_ditance_to_target = dist_to_target
