class_name InteractiveCamera
extends Camera2D

var drag_enabled : bool = false
var drag_vector := Vector2.ZERO

var zoom_increment : float = 0.1 # percent
var zoom_speed : float = 10
var zoom_in_max : float = 2.0
var zoom_out_max : float = 0.4
var zoom_percent : float = 0.5 : set = set_zoom_percent

var zoom_tween : Tween = null
var move_tween : Tween = null
var move_duration : float = 0.6


func _process(_delta: float) -> void:
	if drag_enabled:
		global_position -= drag_vector

func _unhandled_input(event: InputEvent) -> void:
	poll_drag_inputs(event)
	poll_zoom_inputs(event)


# TWEEN MOVEMENT -----------------------------------------------------------------------------------
func move_to(new_position : Vector2, duration := move_duration) -> void:
	cancel_move()
	move_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	move_tween.tween_property(self, "global_position", new_position, duration)

func cancel_move() -> void:
	if move_tween: move_tween.kill()

func is_moving() -> bool:
	return move_tween and move_tween.is_running()


# DRAGGING------------------------------------------------------------------------------------------
func reset_drag_vector():
	drag_vector = Vector2.ZERO

func poll_drag_inputs(event : InputEvent) -> void:
	# START/END DRAG
	if event is InputEventMouseButton:
		drag_enabled = event.is_pressed()
		if event.is_pressed() and not event.is_echo():
			cancel_move()
	# UPDATE DRAG
	if event is InputEventMouseMotion:
		if drag_enabled:
			drag_vector = event.relative / zoom.x
			# event.relative is not a reliable way to see if movement has stopped
			# the timer below makes sure the vector is zeroed if no motion is detected
			get_tree().create_timer(0.001).timeout.connect(reset_drag_vector)


# ZOOMING ------------------------------------------------------------------------------------------
func poll_zoom_inputs(event : InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		zoom_by(zoom_increment)
	elif event.is_action_pressed("zoom_out"):
		zoom_by(-zoom_increment)

func zoom_by(amount : float) -> void:
	zoom_percent += amount
	cancel_zoom()
	zoom_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	zoom_tween.tween_method(update_zoom, zoom, get_zoom_target(), 0.6)

func set_zoom_percent(value : float) -> void:
	value = clamp(value, 0.0, 1.0)
	zoom_percent = value

func update_zoom(new_zoom : Vector2) -> void:
	var last_mouse_pos = get_local_mouse_position()
	zoom = new_zoom
	if not (is_moving() or drag_enabled):
		# move toward mouse if not moving in other ways
		var curr_mouse_pos = get_local_mouse_position()
		global_position += last_mouse_pos - curr_mouse_pos

func cancel_zoom() -> void:
	if zoom_tween: zoom_tween.kill()

func get_zoom_target() -> Vector2:
	return Vector2.ONE * lerp(zoom_out_max, zoom_in_max, zoom_percent)

func get_zoom_scale() -> float:
	return inverse_lerp(zoom_out_max, zoom_in_max, zoom.x)

func is_zooming() -> bool:
	return zoom_tween and zoom_tween.is_running()
