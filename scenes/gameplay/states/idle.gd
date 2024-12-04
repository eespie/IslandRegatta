extends "res://components/state_machine/state.gd"

@export_group('States')
@export var next_state : State


func enter() -> void:
	pass

func process_input(event: InputEvent) -> State:
	if event is InputEventMouseButton:
		if event.is_pressed():
			pass
	# Not relevant
	return null

func is_hit(label: Control, event: InputEvent) -> bool:
	return label.get_rect().has_point(label.position + event.global_position - label.global_position)
	
