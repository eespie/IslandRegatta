extends Camera2D

@export var zoom_speed : float = 10
@export var zoom_min : float = 0.09


var zoom_target :Vector2
var dragStartMousePos = Vector2.ZERO
var dragStartCameraPos = Vector2.ZERO
var isDragging : bool = false

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


func ClickAndDrag():
	if !isDragging and Input.is_action_just_pressed("camera_pan"):
		dragStartMousePos = get_viewport().get_mouse_position()
		dragStartCameraPos = position
		isDragging = true
		
	if isDragging and Input.is_action_just_released("camera_pan"):
		isDragging = false
		
	if isDragging:
		var moveVector : Vector2 = get_viewport().get_mouse_position() - dragStartMousePos
		position = dragStartCameraPos - moveVector * 1/zoom.x
		
