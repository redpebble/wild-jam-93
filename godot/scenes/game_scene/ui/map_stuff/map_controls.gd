extends MarginContainer

signal zoom_in_pressed
signal zoom_out_pressed
signal refocus_pressed

@onready var zoom_in_button: Button = %ZoomInButton
@onready var zoom_out_button: Button = %ZoomOutButton
@onready var refocus_button: Button = %RefocusButton

func _ready() -> void:
	zoom_in_button.pressed.connect(zoom_in_pressed.emit)
	zoom_out_button.pressed.connect(zoom_out_pressed.emit)
	refocus_button.pressed.connect(refocus_pressed.emit)
