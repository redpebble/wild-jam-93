@tool
class_name NetworkVertex
extends Node2D

@export var radius: float = 15.0 :
	set(val):
		radius = val
		queue_redraw()

@export var color: Color = Color.WHITE :
	set(val):
		color = val
		queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color, true, -1, true)

func _ready() -> void:
	if Engine.is_editor_hint(): return
	pass

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	pass
