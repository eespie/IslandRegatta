extends Boat

# Represent boat cell

# Boat setup
@export_category('Boat Setup')
@export var boat_name : String

@export_category('Boat Points')
@export_range(0, 5) var rotation_points : int
@export_range(0, 5) var speed_loss_in_rotation_points : int
@export_range(0, 5) var inertia_points : int
@export_range(0, 5) var max_speed_points : int

@export var rotation_speed_curve : Curve
@export var speed_loss_in_rotation_ratio_curve : Curve
@export var inertia_curve : Curve
@export var max_speed_ratio_curve : Curve

var speed_loss_factor_in_rotation : float
var rotation_speed : float
var linear_inertia : float
var max_speed_ratio : float

@onready var label_name = %Name
@onready var label_speed = %Speed
@onready var next_tile = %NextTile
@onready var target_tile = %TargetTile
@onready var real_boat = %RealBoat
@onready var boat_icon = %BoatIcon
@onready var polar = %Polar
@onready var boat_fsm = %BoatFSM

# Tiles position
var curr_tile_pos : Vector2

var current_linear_speed : float
var next_state : String = 'AtCenter'
var current_direction : int
var next_dir : int

var race : Node
var map : Map
var wind : Wind

# Called when the node enters the scene tree for the first time.
func _ready():
	# Boat setup
	rotation_speed = rotation_speed_curve.sample(rotation_points / 5.0)
	speed_loss_factor_in_rotation = speed_loss_in_rotation_ratio_curve.sample(speed_loss_in_rotation_points / 5.0)
	linear_inertia = inertia_curve.sample(inertia_points / 5.0)
	max_speed_ratio = max_speed_ratio_curve.sample(max_speed_points / 5.0)
	
	print("rotation speed %f" % [rotation_speed])
	print("speed loss factor in rotation %f" % [speed_loss_factor_in_rotation])
	print("linear inertia %f" % [linear_inertia])
	print("max speed ratio %f" % [max_speed_ratio])
	
	# Position 1 of 6
	current_direction = 0
	set_linear_speed(0.0)
	next_dir = 0
	EventBus.sig_race_start.connect(race_start)
	real_boat.boat = self
	boat_icon.boat = self
	boat_fsm.boat = self
	boat_fsm.init_fsm()
	label_name.set_text(boat_name)

func change_state():
	boat_fsm.change_state_to(next_state)

func race_start():
	next_tile.map = map
	target_tile.map = map
	next_tile.set_tile_pos(map.get_tile_pos(position))
	update_target_tile()
	next_state = 'AtCenter'
	change_state()

# turn +1 cw -1 acw
func rotate_boat():
	current_direction += next_dir
	next_dir = 0
	next_state = 'Translating'
	real_boat.rotate_boat(current_direction, rotation_speed)

func translate_boat():
	next_state = 'AtCenter'
	var speed := get_speed()
	real_boat.translate_boat(speed * time_scale, grid_dist, linear_inertia)


func get_speed() -> float:
	var boat_rotation : float = 30.0 + 60.0 * current_direction
	var wind_dir : int = wind.get_wind_dir(position)
	var tws : int = wind.get_wind_speed(position)
	var twa : int = normalize_rotation(boat_rotation - wind_dir)
	if twa > 180:
		twa = 360 - twa
	var speed : float = polar.get_speed(twa, tws) * max_speed_ratio
	#print("wind %d TWA %d - TWS %d - boat %f speed %f" % [wind_dir, twa, tws, boat_rotation, speed])
	return speed


func set_linear_speed(speed):
	current_linear_speed = speed
	label_speed.set_text("%.1f" % [speed * 1.852 / time_scale])


func adjust_speed_for_rotation():
	set_linear_speed(current_linear_speed * speed_loss_factor_in_rotation)

func normalize_rotation(rot : float) -> int:
	while rot > 360:
		rot -= 360
	while rot < 0:
		rot += 360
	return roundi(rot)

func recenter():
	real_boat.recenter()
	curr_tile_pos = next_tile.tile_pos
	position = map.get_pos_from_tile(curr_tile_pos)
	next_tile.set_tile_pos(target_tile.tile_pos)
	# compute the new target from the current dir
	update_target_tile()
	position_tiles()

func position_tiles():
	next_tile.set_position(map.get_pos_from_tile(next_tile.tile_pos) - position)
	target_tile.set_position(map.get_pos_from_tile(target_tile.tile_pos) - position)

func update_target_tile():
	var next_pos : Vector2 = map.get_pos_from_tile(next_tile.tile_pos)
	var target_rotation : float = 30.0 + 60.0 * (current_direction + next_dir)
	var target_pos : Vector2 = next_pos + Vector2.UP.rotated(deg_to_rad(target_rotation)) * grid_dist
	target_tile.set_tile_pos(map.get_tile_pos(target_pos))

func update_next_tile():
	var target_rotation : float = 30.0 + 60.0 * (current_direction + next_dir)
	next_tile.set_tile_pos(map.get_tile_pos(position))
	var target_pos : Vector2 = map.get_pos_from_tile(next_tile.tile_pos) + Vector2.UP.rotated(deg_to_rad(target_rotation)) * grid_dist
	target_tile.set_tile_pos(map.get_tile_pos(target_pos))

func turn_left():
	next_dir -= 1
	update_target_tile()
	position_tiles()

func turn_right():
	next_dir += 1
	update_target_tile()
	position_tiles()

func turn_left_blocked():
	next_dir -= 1
	update_next_tile()
	position_tiles()
	if not next_tile.is_blocked:
		next_state = 'AtCenter'
		change_state()

func turn_right_blocked():
	next_dir += 1
	update_next_tile()
	position_tiles()
	if not next_tile.is_blocked:
		next_state = 'AtCenter'
		change_state()

func cancel_turn():
	next_dir = 0
	update_target_tile()
	position_tiles()


func get_boat_offest()-> Vector2:
	return real_boat.position
