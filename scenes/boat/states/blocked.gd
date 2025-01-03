extends MachineState

# State Idle
func _deferred_enter() -> void:
	Log.debug("BoatFSM enter Blocked")
	FSM.boat.next_dir = 0
	FSM.boat.set_linear_speed(0.0)

func _exit(_next_state: MachineState) -> void:
	Log.debug("BoatFSM exit Blocked next %s" % [_next_state])

func update(_delta):
	if Input.is_action_just_pressed("turn_left"):
		FSM.boat.turn_left_blocked()
	if Input.is_action_just_pressed("turn_right"):
		FSM.boat.turn_right_blocked()
