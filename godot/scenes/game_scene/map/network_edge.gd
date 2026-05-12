@tool
class_name NetworkEdge
extends Node2D

func valid_node(path, other) -> Node:
	var n_new = get_node(path)
	if n_new and (n_new is NetworkNode) and (path != other): return n_new
	print("Invalid NetworkNode")
	return null

var node_a: NetworkNode = null
@export var node_path_a: NodePath :
	set(path):
		if path == NodePath():
			node_a = null
		else:
			var n = valid_node(path, node_path_b)
			if not n: return
			node_a = n
		node_path_a = path
		queue_redraw()

var node_b: NetworkNode = null
@export var node_path_b: NodePath :
	set(path):
		if path == NodePath():
			node_b = null
		else:
			var n = valid_node(path, node_path_a)
			if not n: return
			node_b = n
		node_path_b = path
		queue_redraw()

func _draw() -> void:
	if not (node_a and node_b): return
	var pos_a = to_local(node_a.global_position)
	var pos_b = to_local(node_b.global_position)
	draw_line(pos_a, pos_b, Color.WHITE, 7, true)

func _ready() -> void:
	if Engine.is_editor_hint(): return
	pass

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
		return
	pass
