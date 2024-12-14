extends Node

@onready var map = %Map
@onready var race_fsm = %RaceFSM
@onready var wind = %Wind

func _ready():
	get_tree().set_group("Boat", "race", self)
	get_tree().set_group("Boat", "wind", wind)
	EventBus.sig_race_start.emit()
