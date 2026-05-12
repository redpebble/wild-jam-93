@tool
class_name NetworkEdge
extends Node2D

func vert_is_invalid(vert, other) -> bool:
	if vert == null or vert != other: return false
	print("Invalid NetworkVertex")
	return true

@export var vertex_a: NetworkVertex = null :
	set(vert):
		if vert_is_invalid(vert, vertex_b): return
		vertex_a = vert
		editor_redraw()

@export var vertex_b: NetworkVertex = null :
	set(vert):
		if vert_is_invalid(vert, vertex_a): return
		vertex_b = vert
		editor_redraw()

var color: Color = Color.WHITE

func editor_redraw() -> void:
	if Engine.is_editor_hint(): queue_redraw()

func _draw() -> void:
	if not (vertex_a and vertex_b): return
	var pos_a = to_local(vertex_a.global_position)
	var pos_b = to_local(vertex_b.global_position)
	draw_line(pos_a, pos_b, color, 7, true)

func _ready() -> void:
	if Engine.is_editor_hint(): return

func _process(_delta: float) -> void:
	editor_redraw()

func has_vertex(vert) -> bool:
	if vert == vertex_a or vert == vertex_b: return true
	return false

func has_vertices(vert1, vert2) -> bool:
	return has_vertex(vert1) and has_vertex(vert2)
