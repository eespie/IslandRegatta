extends MachineState

# State AtCenter
func _deferred_enter() -> void:
	Log.debug("BoatFSM enter AtCenter")
	FSM.boat.recenter()
	FSM.boat.rotate_boat()

func _exit(_next_state: MachineState) -> void:
	Log.debug("BoatFSM exit AtCenter next %s" % [_next_state])
