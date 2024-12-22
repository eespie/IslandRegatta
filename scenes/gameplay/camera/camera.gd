extends Camera2D

@export var zoom_speed : float = 10
@export var zoom_min : float = 0.09


var zoom_target :Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	zoom_target = zoom


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Zoom(delta)


func Zoom(delta):
	if Input.is_action_pressed("camera_zoom_in"):
		zoom_target *= 1.1
		
	if Input.is_action_pressed("camera_zoom_out"):
		zoom_target *= 0.9
	
	if zoom_target.x < zoom_min:
		zoom_target = Vector2(zoom_min, zoom_min)
	zoom = zoom.slerp(zoom_target, zoom_speed * delta)
