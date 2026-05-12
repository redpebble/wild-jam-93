@tool
class_name NetworkEdge
extends Node2D

@export var node_path_a: NodePath :
	set(val):
		node_path_a = val
		queue_redraw()

@export var node_path_b: NodePath :
	set(val):
		node_path_b = val
		queue_redraw()

func _draw() -> void:
	if not (node_path_a and node_path_b): return
	var node_a = get_node(node_path_a)
	var node_b = get_node(node_path_b)
	if not (node_a and node_b): return
	draw_line(to_local(node_a.global_position), to_local(node_b.global_position), Color.WHITE, 7, true)

func _ready() -> void:
	if Engine.is_editor_hint(): return
	pass

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
		return
	pass
