@icon("res://components/behaviour/state-machines/hierarchical-state-machine/state_icon.png")
class_name MachineState extends Node

signal entered
signal finished(next_state)

var FSM: FiniteStateMachine


func ready() -> void:
	pass


func _enter() -> void:
	call_deferred("_deferred_enter")

func _deferred_enter():
	pass

func _exit(_next_state: MachineState) -> void:
	pass
	

func handle_input(_event: InputEvent):
	pass	


func physics_update(_delta):
	pass
	
	
func update(_delta):
	pass
	
