extends Node

@onready var gameplay_fsm = %GameplayFSM


func _ready():
	EventBus.sig_race_start.emit()
