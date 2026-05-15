@tool
class_name NetworkMap
extends Node

signal start_vertex_changed(vertex: NetworkVertex)
signal selected_vertex_changed(vertex : NetworkVertex, adjacency : bool)

var edge_list: Array[NetworkEdge] = []
var vertex_list: Array[NetworkVertex] = []

@export var start_vertex: NetworkVertex :
	set(vertex):
		start_vertex = vertex
		start_vertex_changed.emit(start_vertex)
		color_start_adjacent()

@onready var selected_vertex: NetworkVertex = start_vertex :
	set(vertex):
		selected_vertex = vertex
		var adjacency = are_adjacent(start_vertex, selected_vertex)
		selected_vertex_changed.emit(selected_vertex, adjacency)
		for v in vertex_list:
			v.selected = (v == vertex)
			v.queue_redraw()


func init_lists() -> void:
	edge_list.clear()
	vertex_list.clear()
	edge_list.append_array($Edges.get_children().filter(func(n): return n is NetworkEdge))
	vertex_list.append_array($Vertices.get_children().filter(func(n): return n is NetworkVertex))

func editor_redraw() -> void:
	if Engine.is_editor_hint():
		for edge in edge_list: edge.editor_redraw()
		for vert in vertex_list: vert.editor_redraw()

func color_start_adjacent() -> void:
	if Engine.is_editor_hint(): init_lists()
	for edge in edge_list:
		edge.color = Color.WHITE if edge.has_vertex(start_vertex) else Color.DARK_SLATE_GRAY
		edge.queue_redraw()
	for vert in vertex_list:
		if vert == start_vertex:
			vert.color = Color.ORANGE
		else:
			vert.color = Color.WHITE if are_adjacent(vert, start_vertex) else Color.DARK_SLATE_GRAY
		vert.queue_redraw()

func _ready() -> void:
	init_lists()
	for v in vertex_list:
		v.lclicked.connect(_on_vertex_lclicked)
	color_start_adjacent()

func _process(_delta: float) -> void:
	editor_redraw()

func set_start_selected() -> void:
	start_vertex = selected_vertex

func are_adjacent(vertex1, vertex2) -> bool:
	for edge in edge_list:
		if edge.is_vertices(vertex1, vertex2): return true
	return false

func _on_vertex_lclicked(vertex) -> void:
	selected_vertex = vertex
