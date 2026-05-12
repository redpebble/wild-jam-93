@tool
class_name NetworkEdge
extends Node2D

func path_is_valid(path, other) -> bool:
	if path == NodePath(): return true
	var n_new = get_node(path)
	var n_other = get_node(other)
	if n_new and (n_new is NetworkNode) and (n_new != n_other): return true
	print("Invalid NetworkNode")
	return false

@export var node_a: NodePath :
	set(path):
		if not path_is_valid(path, node_b): return
		node_a = path
		queue_redraw()

@export var node_b: NodePath :
	set(path):
		if not path_is_valid(path, node_a): return
		node_b = path
		queue_redraw()

func _draw() -> void:
	if not (node_a and node_b): return
	var n_a = get_node(node_a)
	var n_b = get_node(node_b)
	if not (n_a and n_b): return
	var pos_a = to_local(n_a.global_position)
	var pos_b = to_local(n_b.global_position)
	draw_line(pos_a, pos_b, Color.WHITE, 7, true)

func _ready() -> void:
	if Engine.is_editor_hint(): return
	pass

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
		return
	pass
