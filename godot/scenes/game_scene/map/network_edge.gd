@tool
class_name NetworkEdge
extends Node2D

func node_is_invalid(node, other) -> bool:
	if node == null or node != other: return false
	print("Invalid NetworkVertex")
	return true

func editor_redraw() -> void:
	if Engine.is_editor_hint(): queue_redraw()

@export var vertex_a: NetworkVertex = null :
	set(node):
		if node_is_invalid(node, vertex_b): return
		vertex_a = node
		editor_redraw()

@export var vertex_b: NetworkVertex = null :
	set(node):
		if node_is_invalid(node, vertex_a): return
		vertex_b = node
		editor_redraw()

func _draw() -> void:
	if not (vertex_a and vertex_b): return
	var pos_a = to_local(vertex_a.global_position)
	var pos_b = to_local(vertex_b.global_position)
	draw_line(pos_a, pos_b, Color.WHITE, 7, true)

func _ready() -> void:
	if Engine.is_editor_hint(): return

func _process(_delta: float) -> void:
	editor_redraw()
