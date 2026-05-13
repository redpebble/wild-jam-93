@tool
class_name NetworkVertex
extends Area2D

signal lclicked(vertex)
signal rclicked(vertex)

@export var radius: float = 15.0 :
	set(val):
		radius = val
		$CollisionShape2D.scale = Vector2(val / 10, val / 10)
		queue_redraw()

var color: Color = Color.WHITE

var selected: bool = false

func editor_redraw() -> void:
	if Engine.is_editor_hint(): queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color, true, -1, true)
	if selected:
		draw_circle(Vector2.ZERO, radius + 5, Color.WHITE, false, 1, true)

func _ready() -> void:
	if Engine.is_editor_hint(): return
	pass

func _process(_delta: float) -> void:
	editor_redraw()


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not (event is InputEventMouseButton and event.is_pressed()): return
	if event.button_index == 1: lclicked.emit(self)
	if event.button_index == 2: rclicked.emit(self)
