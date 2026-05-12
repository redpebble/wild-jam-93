@tool
class_name NetworkEdge
extends Node2D

func path_is_invalid(path, other) -> bool:
	if not Engine.is_editor_hint(): return false
	if path == NodePath(): return false
	var node = get_node(path)
	if (node is NetworkVertex) and (path != other): return false
	print("Invalid NetworkVertex")
	return true

func editor_redraw() -> void:
	if Engine.is_editor_hint(): queue_redraw()

@export var vertex_path_a: NodePath :
	set(path):
		if path_is_invalid(path, vertex_path_b): return
		vertex_path_a = path
		editor_redraw()

@export var vertex_path_b: NodePath :
	set(path):
		if path_is_invalid(path, vertex_path_a): return
		vertex_path_b = path
		editor_redraw()

@onready var vertex_a: NetworkVertex = get_node(vertex_path_a)
@onready var vertex_b: NetworkVertex = get_node(vertex_path_b)

func _draw() -> void:
	if Engine.is_editor_hint():
		vertex_a = get_node(vertex_path_a)
		vertex_b = get_node(vertex_path_b)
	if not (vertex_a and vertex_b): return
	var pos_a = to_local(vertex_a.global_position)
	var pos_b = to_local(vertex_b.global_position)
	draw_line(pos_a, pos_b, Color.WHITE, 7, true)

func _ready() -> void:
	if Engine.is_editor_hint(): return

func _process(_delta: float) -> void:
	editor_redraw()
