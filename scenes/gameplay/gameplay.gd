extends Node

@onready
var StateMachine = $StateMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	StateMachine.init()

func start():
	SaveGame.load_game()
	StateMachine.start_game()

func _process(delta):
	StateMachine.process_frame(delta)
	
func _physics_process(delta):
	StateMachine.process_physics(delta)
	
func _input(event):
	StateMachine.process_input(event)
