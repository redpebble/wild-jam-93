extends MarginContainer

signal refocus_pressed
signal zoom_slider_value_changed

@onready var zoom_slider: VSlider = %ZoomSlider
@onready var zoom_in_button: Button = %ZoomInButton
@onready var zoom_out_button: Button = %ZoomOutButton
@onready var refocus_button: Button = %RefocusButton

var zoom_button_increment = 0.2 # percent change

func _ready() -> void:
	zoom_in_button.pressed.connect(_on_zoom_in_button_pressed)
	zoom_out_button.pressed.connect(_on_zoom_out_button_pressed)
	refocus_button.pressed.connect(refocus_pressed.emit)
	zoom_slider.value_changed.connect(zoom_slider_value_changed.emit)

func silent_set_zoom_slider_value(value : float) -> void:
	zoom_slider.value_changed.disconnect(zoom_slider_value_changed.emit)
	zoom_slider.value = value
	zoom_slider.value_changed.connect(zoom_slider_value_changed.emit)

func _on_zoom_in_button_pressed() -> void:
	zoom_slider.value += zoom_button_increment

func _on_zoom_out_button_pressed() -> void:
	zoom_slider.value -= zoom_button_increment
