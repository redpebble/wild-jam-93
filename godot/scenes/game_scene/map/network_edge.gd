@tool
class_name NetworkEdge
extends Node2D

func vert_is_invalid(vertex, other) -> bool:
	if vertex == null or vertex != other: return false
	print("Invalid NetworkVertex")
	return true

@export var vertex_a: NetworkVertex = null :
	set(vertex):
		if vert_is_invalid(vertex, vertex_b): return
		vertex_a = vertex
		editor_redraw()

@export var vertex_b: NetworkVertex = null :
	set(vertex):
		if vert_is_invalid(vertex, vertex_a): return
		vertex_b = vertex
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

func has_vertex(vertex) -> bool:
	if vertex == vertex_a or vertex == vertex_b: return true
	return false

func is_vertices(vertex1, vertex2) -> bool:
	return (vertex1 == vertex_a and vertex2 == vertex_b) or (vertex1 == vertex_b and vertex2 == vertex_a)
