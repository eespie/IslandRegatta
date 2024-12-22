extends Boat

@export var grid_dist : float = 120.0
@export var time_scale : float = 5.0

@onready var next_tile = %NextTile
@onready var target_tile = %TargetTile
@onready var boat_icon = %BoatIcon
@onready var polar = %Polar
@onready var boat_fsm = %BoatFSM

# Tiles position
var curr_tile_pos : Vector2

var rotation_speed : float = 60.0
var next_state : String = 'AtCenter'
var current_direction : int
var next_dir : int

var tween : Tween

var race : Node
var map : Map
var wind : Wind

# Called when the node enters the scene tree for the first time.
func _ready():
	# Position 1 of 6
	boat_icon.set_rotation_degrees(30)
	current_direction = 0
	next_dir = 0
	EventBus.sig_race_start.connect(race_start)
	boat_icon.boat = self
	boat_fsm.boat = self
	boat_fsm.init_fsm()

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
	boat_icon.rotate_boat(current_direction, rotation_speed)

func translate_boat():
	if next_tile.is_blocked:
		next_state = 'Blocked'
		next_dir = 0
		change_state()
	else:
		next_state = 'AtCenter'
		var speed = get_speed() * time_scale
		boat_icon.translate_boat(speed, grid_dist)

func get_speed() -> float:
	var boat_rotation : float = 30.0 + 60.0 * current_direction
	var wind_at_pos : Vector2i = wind.get_wind(position)
	var wind_dir : int = wind_at_pos.x
	var tws : int = wind_at_pos.y
	var twa : int = normalize(boat_rotation - wind_dir)
	if twa > 180:
		twa = 360 - twa
	var speed : float = polar.get_speed(twa, tws)
	print("TWA %d - TWS %d - boat %f speed %f" % [twa, tws, boat_rotation, speed])
	return speed

func normalize(rot : float) -> int:
	while rot > 360:
		rot -= 360
	while rot < 0:
		rot += 360
	return roundi(rot)

func recenter():
	boat_icon.recenter()
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
