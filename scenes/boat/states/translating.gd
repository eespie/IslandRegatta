extends MachineState

# State Translating
func _enter() -> void:
	FSM.boat.translate_boat()


func _exit(_next_state: MachineState) -> void:
	pass
	

func handle_input(event: InputEvent):
	if event.is_action_pressed("turn_left"):
		FSM.boat.turn_left()
	if event.is_action_pressed("turn_right"):
		FSM.boat.turn_right()
	if event.is_action_pressed("cancel_turn"):
		FSM.boat.cancel_turn()


func physics_update(_delta):
	pass
	
	
func update(_delta):
	pass
	
