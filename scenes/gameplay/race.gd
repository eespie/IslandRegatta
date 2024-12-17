extends Node

@onready var map = %Map
@onready var wind = %Wind
@onready var umpire = $Umpire

@onready var race_fsm = %RaceFSM

func _ready():
	get_tree().set_group("Boat", "race", self)
	get_tree().set_group("Boat", "wind", wind)
	
	wind.map = map
	
	EventBus.sig_race_start.emit()
