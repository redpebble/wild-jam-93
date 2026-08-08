extends Control

@export var show_on_ready : bool = true

func _ready() -> void:
	if show_on_ready:
		show()
