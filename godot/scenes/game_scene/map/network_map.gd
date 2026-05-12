@tool
class_name NetworkMap
extends Node

var edges: Array[NetworkEdge] = []
var verts: Array[NetworkVertex] = []

func color_start_adjacent() -> void:
	if Engine.is_editor_hint(): init()
	for edge in edges:
		edge.color = Color.WHITE if edge.has_vertex(start_vertex) else Color.DARK_SLATE_GRAY
	for vert in verts:
		if vert == start_vertex:
			vert.color = Color.ORANGE
		else:
			vert.color = Color.WHITE if verts_are_adjacent(vert, start_vertex) else Color.DARK_SLATE_GRAY

@export var start_vertex: NetworkVertex :
	set(vert):
		start_vertex = vert
		if Engine.is_editor_hint():
			color_start_adjacent()

func init() -> void:
	edges.clear()
	verts.clear()
	edges.append_array($Edges.get_children().filter(func(n): return n is NetworkEdge))
	verts.append_array($Vertices.get_children().filter(func(n): return n is NetworkVertex))

func editor_redraw() -> void:
	if Engine.is_editor_hint():
		for edge in edges: edge.editor_redraw()
		for vert in verts: vert.editor_redraw()

func _ready() -> void:
	init()
	color_start_adjacent()

func _process(_delta: float) -> void:
	editor_redraw()

func verts_are_adjacent(vert1, vert2) -> bool:
	for edge in edges:
		if edge.has_vertices(vert1, vert2): return true
	return false
