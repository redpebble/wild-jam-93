class_name InteractiveCamera
extends Camera2D

@export var hide_mouse_while_dragging : bool = false

var mouse_press_position := Vector2.ZERO
var drag_enabled : bool = false
var drag_vector := Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	# START/END DRAG
	if event is InputEventMouseButton:
		drag_enabled = event.is_pressed()
		if event.is_pressed():
			if not event.is_echo():
				mouse_press_position = event.position
				if hide_mouse_while_dragging:
					Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# UPDATE DRAG
	if event is InputEventMouseMotion:
		if drag_enabled:
			drag_vector = event.relative
			# event.relative is not a reliable way to see if movement has stopped
			# the timer below makes sure it is stopped
			get_tree().create_timer(0.001).timeout.connect(reset_drag_vector)

func _process(_delta: float) -> void:
	if drag_enabled:
		global_position -= drag_vector

func reset_drag_vector():
	drag_vector = Vector2.ZERO
