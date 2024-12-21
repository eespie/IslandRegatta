extends MachineState

# State Idle
func _enter() -> void:
	pass

func handle_input(event: InputEvent):
	if event.is_action_pressed("turn_left"):
		FSM.boat.turn_left()
	if event.is_action_pressed("turn_right"):
		FSM.boat.turn_right()
	if event.is_action_pressed("cancel_turn"):
		FSM.boat.cancel_turn()
