extends Node

# In game variables
var level: int = 0
var brick_life: int = 0
var ball_max_count: float = 1

# Permanent variables
var max_level: int = 0
var total_points: int = 0
var replay_bonus : int = 0
var items = {}

# Non saved variables
var is_replay_asked : int = 0
var state = null
var speed_factor : float = 1.0

func _ready():
	EventBus.sigAddScorePoints.connect(update_total_points)
	EventBus.sigStoreItemPurchased.connect(_on_item_purchased)
	EventBus.sigNextLevel.connect(_on_next_level)
	EventBus.sigAddNewBalls.connect(_on_add_new_ball)
	EventBus.sigNoBallsRemaining.connect(_on_end_of_round)
	EventBus.sigEndStateMovingBricks.connect(_on_end_moving_bricks)
	EventBus.sigEndOfGame.connect(_on_end_of_game)
	EventBus.sigEnterState.connect(_on_enter_state)
	EventBus.sigExitState.connect(_on_exit_state)
	EventBus.sigSpeedFactorChanged.connect(_on_speed_factor_changed)

func get_number_of_brick_lines() -> int:
	return min(floori(level / 50.0) + 1, 3)

func update_replay_bonus(bonus : int):
	replay_bonus += bonus
	EventBus.sigReplayBonusUpdated.emit(bonus)
	if bonus < 1:
		is_replay_asked += 1
		Game.restart_scene()

func update_total_points(points : int):
	total_points += points
	if total_points < 0:
		total_points = 0
	EventBus.sigScorePointsUpdated.emit()

func add_item(_name : String):
	var amount = 0
	if items.has(_name):
		amount = items[_name]
	items[_name] = amount + 1
	
func remove_item(_name : String):
	if items.has(_name):
		items[_name] = items[_name] - 1
		SaveGame.save_game()
		EventBus.sigBonusesUpdated.emit()

func _on_speed_factor_changed(spd_fact: float):
	speed_factor = spd_fact

func _on_next_level(lvl : int):
	level = lvl
	brick_life = lvl
	if level > max_level:
		max_level = level
		EventBus.sigMaxLevel.emit(max_level)

func _on_add_new_ball(balls : float):
	ball_max_count += balls
	if ball_max_count < (level / 2.0):
		ball_max_count = level / 2.0
	EventBus.sigBallCountUpdated.emit(floori(ball_max_count))

func _on_end_of_round():
	is_replay_asked = 0
	SaveGame.save_game()

func _on_end_moving_bricks():
	SaveGame.save_game()

func _on_end_of_game():
	EventBus.sigAddScorePoints.emit(level)
	level = 0
	brick_life = 0
	ball_max_count = 1
	SaveGame.save_game()

func _on_enter_state(_state : String):
	state = _state

func _on_exit_state(_state : String):
	state = null

func _on_item_purchased(_name : String, amount : int):
	total_points -= amount
	SaveGame.save_permanent_data()
	EventBus.sigScorePointsUpdated.emit()

func save_game():
	var save_dict = {
		"name" : "GameManager",
		"level" : level,
		"brick_life" : brick_life,
		"ball_max_count" : ball_max_count,
	}
	return save_dict

func load_game(node_data):
	level = node_data["level"]
	brick_life = node_data["brick_life"]
	EventBus.sigNextLevel.emit(level)
	ball_max_count = node_data["ball_max_count"]
	EventBus.sigBallCountUpdated.emit(floori(ball_max_count))
	
func save_permanent_data():
	var save_dict = {
		"name" : "GameManager",
		"max_level" : max_level,
		"total_points" : total_points,
		"replay_bonus" : replay_bonus,
		"items" : items,
	}
	return save_dict

func load_permanent_data(node_data):
	max_level = node_data["max_level"]
	EventBus.sigMaxLevel.emit(max_level)
	total_points = node_data["total_points"]
	EventBus.sigScorePointsUpdated.emit()
	items = node_data["items"]
	replay_bonus = node_data["replay_bonus"]
	if is_replay_asked > 0:
		replay_bonus -= is_replay_asked
	EventBus.sigReplayBonusUpdated.emit(0)
