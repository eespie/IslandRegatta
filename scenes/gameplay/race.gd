extends Node

@onready var map = %Map
@onready var wind = %Wind
@onready var umpire = $Umpire

@onready var race_fsm = %RaceFSM

func _ready():
	get_tree().set_group("Race", "race", self)
	get_tree().set_group("Race", "wind", wind)
	get_tree().set_group("Race", "map", map)
		
	EventBus.sig_race_start.emit()
