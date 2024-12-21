extends Sprite2D

var boat : Boat
var tween : Tween

func rotate_boat(direction : float, rotation_speed : float):
	var target_rotation : float = 30.0 + 60.0 * direction
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	var duration : float = abs(rotation_degrees - target_rotation) / rotation_speed
	tween.tween_property(self, 'rotation_degrees', target_rotation, duration).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(boat.change_state)

func translate_boat(speed : float, dist : float):
	var duration : float = 0.1
	if speed > 0.0:
		duration = dist / speed
	var velocity : Vector2 = Vector2.UP.rotated(get_rotation()) * speed
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, 'position', velocity * duration, duration)
	tween.tween_callback(boat.change_state)

func recenter():
	set_position(Vector2.ZERO)
