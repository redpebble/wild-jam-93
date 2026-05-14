extends Control

@onready var refocus_button: Button = %RefocusButton
@onready var zoom_in_button: Button = %ZoomInButton
@onready var zoom_out_button: Button = %ZoomOutButton
@onready var map_display: MapDisplay = %MapDisplay


func _ready() -> void:
	refocus_button.pressed.connect(_on_refocus_button_pressed)
	zoom_in_button.pressed.connect(_on_zoom_in_button_pressed)
	zoom_out_button.pressed.connect(_on_zoom_out_button_pressed)

# CAMERA CONTROL -----------------------------------------------------------------------------------
func _on_refocus_button_pressed() -> void:
	map_display.refocus_camera()

func _on_zoom_in_button_pressed() -> void:
	map_display.zoom_camera_in()

func _on_zoom_out_button_pressed() -> void:
	map_display.zoom_camera_out()
