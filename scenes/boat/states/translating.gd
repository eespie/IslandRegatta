extends MachineState

# State Translating
func _deferred_enter() -> void:
	Log.debug("BoatFSM enter Translating")
	if FSM.boat.next_tile.is_blocked:
		FSM.change_state_to('Blocked')
	else:
		FSM.boat.translate_boat()

func _exit(_next_state: MachineState) -> void:
	Log.debug("BoatFSM exit Translating next %s" % [_next_state])

func update(_delta):
	if Input.is_action_just_pressed("turn_left"):
		FSM.boat.turn_left()
	if Input.is_action_just_pressed("turn_right"):
		FSM.boat.turn_right()
