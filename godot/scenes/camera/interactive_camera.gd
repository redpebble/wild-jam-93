class_name InteractiveCamera
extends Camera2D

signal zoom_scale_changed

var drag_enabled : bool = false
var drag_vector := Vector2.ZERO

var zoom_increment : float = 0.1 # percent
var zoom_speed : float = 10
var zoom_in_max : float = 2.0
var zoom_out_max : float = 0.4
var zoom_percent : float = 0.5 : set = set_zoom_percent

var zoom_toward_mouse : bool = false : set = set_zoom_toward_mouse
var zoom_tween : Tween = null
var move_tween : Tween = null
var move_duration : float = 0.6

@onready var zoom_marker: Node2D = $ZoomMarker
@onready var mouse_proxy: Node2D = %MouseProxy


func _ready() -> void:
	zoom_percent = zoom_percent
	zoom_marker.top_level = true
	mouse_proxy.top_level = false

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

func move_by(amount : Vector2, duration := move_duration) -> void:
	move_to(global_position + amount, duration)

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
	var zoom_direction = event.get_action_strength("zoom_in") - event.get_action_strength("zoom_out")
	if zoom_direction:
		var prev_zoom = zoom_percent
		zoom_percent += zoom_increment * zoom_direction
		if zoom_percent != prev_zoom:
			set_zoom_toward_mouse(true)

func update_zoom(new_zoom : Vector2) -> void:
	zoom = new_zoom
	zoom_scale_changed.emit(get_zoom_scale())
	if zoom_toward_mouse:
		# move toward mouse if not moving in other ways
		var zoom_start_position = zoom_marker.get_global_transform_with_canvas().origin
		var displacement = zoom_start_position - mouse_proxy.global_position
		# makeup for displacement with respect to zoom <--- important factor
		global_position += displacement / zoom
		if is_moving() or drag_enabled:
			set_zoom_toward_mouse(false)

func set_zoom_toward_mouse(state : bool) -> void:
	zoom_toward_mouse = state
	if zoom_toward_mouse:
		zoom_marker.global_position = get_global_mouse_position()
		mouse_proxy.position = mouse_proxy.get_global_mouse_position()

func set_zoom_percent(value : float) -> void:
	value = clamp(value, 0.0, 1.0)
	zoom_percent = value
	# Start zoom tween
	cancel_zoom()
	zoom_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	zoom_tween.tween_method(update_zoom, zoom, get_zoom_target(), 0.6)

func cancel_zoom() -> void:
	if zoom_tween: zoom_tween.kill()

func get_zoom_target() -> Vector2:
	return Vector2.ONE * lerp(zoom_out_max, zoom_in_max, zoom_percent)

func get_zoom_scale() -> float:
	return inverse_lerp(zoom_out_max, zoom_in_max, zoom.x)

func is_zooming() -> bool:
	return zoom_tween and zoom_tween.is_running()
