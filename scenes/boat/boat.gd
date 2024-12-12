extends Sprite2D

@onready var boat_fsm = %BoatFSM

var rotation_speed : float = 90.0
var linear_speed : float = 100.0
var next_state : String = 'PreRace'
var current_direction : int
var next_dir : int

var tween : Tween
var race : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	# Position 1 of 6
	set_rotation_degrees(30)
	current_direction = 0
	next_dir = 0
	EventBus.sig_race_start.connect(race_start)
	boat_fsm.boat = self
	boat_fsm.init_fsm()

func change_state():
	boat_fsm.change_state_to(next_state)

func race_start():
	next_state = 'AtCenter'
	change_state()

# turn +1 cw -1 acw
func rotate_boat():
	current_direction += next_dir
	next_dir = 0
	var target_rotation : float = 30.0 + 60.0 * current_direction
	next_state = 'Translating'
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	var duration : float = abs(rotation_degrees - target_rotation) / rotation_speed
	tween.tween_property(self, 'rotation_degrees', target_rotation, duration).set_trans(Tween.TRANS_QUAD)
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


func recenter():
	set_position(race.map.recenter(position))

func turn_left():
	next_dir -= 1

func turn_right():
	next_dir += 1

func cancel_turn():
	next_dir = 0
