extends Node

@onready var map = %Map
@onready var race_fsm = %RaceFSM

func _ready():
	get_tree().set_group("Boat", "race", self)
	EventBus.sig_race_start.emit()
