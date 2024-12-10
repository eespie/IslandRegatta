extends MachineState

# State AtCenter
func _enter() -> void:
	FSM.boat.recenter()
	FSM.boat.rotate_boat()


func _exit(_next_state: MachineState) -> void:
	pass
	

func handle_input(_event: InputEvent):
	pass	

func update(_delta):
	pass
	
