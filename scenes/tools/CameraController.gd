extends Camera2D

@export var zoom_speed : float = 10
@export var zoom_min : float = 0.09

@onready var tile_map_layer = %TileMapLayer
@onready var marker_2d_min = %Marker2DMin
@onready var marker_2d_max = %Marker2DMax

var zoom_target :Vector2
var dragStartMousePos = Vector2.ZERO
var dragStartCameraPos = Vector2.ZERO
var isDragging : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	zoom_target = zoom
	set_cam_limits()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Zoom(delta)
	
func Zoom(delta):
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoom_target *= 1.1
		set_cam_limits()
		
	if Input.is_action_just_pressed("camera_zoom_out"):
		zoom_target *= 0.9
		set_cam_limits()
	
	if zoom_target.x < zoom_min:
		zoom_target = Vector2(zoom_min, zoom_min)
	zoom = zoom.slerp(zoom_target, zoom_speed * delta)

func set_cam_limits():
	pass
	#var vp_size : Vector2 = get_viewport().get_visible_rect().size
		#
	#limit_left = marker_2d_min.position.x + 2.0 * zoom_target.x / vp_size.x
	#limit_right = marker_2d_max.position.x - 2.0 * zoom_target.x / vp_size.x
	#limit_top = marker_2d_min.position.y + 2.0 * zoom_target.y / vp_size.y
	#limit_bottom = marker_2d_max.position.y - 2.0 * zoom_target.y / vp_size.y
	#
	#print("(%f, %f) (%f, %f)" % [limit_left, limit_top, limit_right, limit_bottom])
	#print(position)

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
		
