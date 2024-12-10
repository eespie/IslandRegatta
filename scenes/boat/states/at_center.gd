extends MachineState

# State AtCenter
func _enter() -> void:
	FSM.boat.recenter()
	FSM.boat.rotate_boat(randi_range(-1, 1))


func _exit(_next_state: MachineState) -> void:
	pass
	

func handle_input(_event: InputEvent):
	pass	

func update(_delta):
	pass
	
