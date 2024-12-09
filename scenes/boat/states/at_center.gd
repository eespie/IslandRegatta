extends MachineState


func _enter() -> void:
	FSM.boat.rotate_boat(randi_range(-1, 1))


func _exit(_next_state: MachineState) -> void:
	pass
	

func handle_input(_event: InputEvent):
	pass	


func physics_update(_delta):
	pass
	
	
func update(_delta):
	pass
	
