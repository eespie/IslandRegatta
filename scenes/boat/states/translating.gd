extends MachineState

# State Translating
func _enter() -> void:
	FSM.boat.translate_boat()


func _exit(_next_state: MachineState) -> void:
	pass
	

func handle_input(_event: InputEvent):
	pass	


func physics_update(_delta):
	pass
	
	
func update(_delta):
	pass
	