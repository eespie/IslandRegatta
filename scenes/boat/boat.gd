extends Sprite2D

@onready var boat_fsm = %BoatFSM

var rotation_speed : float = 90.0
var linear_speed : float = 50.0
var next_state : String = 'PreRace'
var current_direction : int

var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	# Position 1 of 6
	set_rotation_degrees(30)
	current_direction = 0
	EventBus.sig_race_start.connect(race_start)
	boat_fsm.boat = self
	boat_fsm.init_fsm()

func change_state():
	boat_fsm.change_state_to(next_state)

func race_start():
	next_state = 'AtCenter'
	change_state()

# turn +1 cw -1 acw
func rotate_boat(turn : int):
	current_direction = (current_direction + turn) % 6
	var target_rotation : float = 30.0 + 60.0 * current_direction
	next_state = 'Translating'
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	var duration : float = abs(rotation_degrees - target_rotation) / rotation_speed
	tween.tween_property(self, 'rotation_degrees', target_rotation, duration)
	tween.tween_callback(change_state)

func translate_boat():
	next_state = 'AtCenter'
	var velocity : Vector2 = Vector2.UP.rotated(rotation) * linear_speed
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	var duration : float = 120.0 / linear_speed
	tween.tween_property(self, 'position', position + velocity * duration, duration)
	tween.tween_callback(change_state)
