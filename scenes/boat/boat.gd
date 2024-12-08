extends Sprite2D

@onready var finite_state_machine = $FiniteStateMachine

var rotation_speed : float = 60.0 # 30 deg/s
var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func rotate_boat(target_rotation : float):
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	var duration : float = abs(rotation_degrees - target_rotation) / rotation_speed
	tween.tween_property(self, 'rotation_degrees', target_rotation, duration)
