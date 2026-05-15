class_name InteractiveCamera
extends Camera2D

var drag_enabled : bool = false
var drag_vector := Vector2.ZERO

var zoom_increment : float = 0.1 # percent
var zoom_speed : float = 10
var zoom_in_max : float = 2.0
var zoom_out_max : float = 0.4
var zoom_percent : float = 0.5 : set = set_zoom_percent

var move_tween : Tween = null
var move_duration : float = 0.6


func _process(delta: float) -> void:
	if drag_enabled:
		global_position -= drag_vector
	update_zoom(delta)

func _unhandled_input(event: InputEvent) -> void:
	poll_drag_inputs(event)
	poll_zoom_inputs(event)


# TWEEN MOVEMENT -----------------------------------------------------------------------------------
func move_to(new_position : Vector2) -> void:
	cancel_move()
	move_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	move_tween.tween_property(self, "global_position", new_position, move_duration)

func cancel_move() -> void:
	if move_tween: move_tween.kill()


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

func set_zoom_percent(value : float) -> void:
	value = clamp(value, 0.0, 1.0)
	zoom_percent = value

func get_zoom_target() -> Vector2:
	return Vector2.ONE * lerp(zoom_out_max, zoom_in_max, zoom_percent)

func update_zoom(delta : float) -> void:
	zoom = lerp(zoom, get_zoom_target(), zoom_speed * delta)
