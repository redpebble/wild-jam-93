@tool
class_name NetworkMap
extends Node

#signal start_vertex_changed(vertex: NetworkVertex) # TODO: Uncomment to allow camera snap

var edge_list: Array[NetworkEdge] = []
var vert_list: Array[NetworkVertex] = []

@export var start_vertex: NetworkVertex :
	set(vert):
		start_vertex = vert
		#start_vertex_changed.emit(start_vertex) # TODO: Uncomment to allow camera snap
		color_start_adjacent()

var selected_vert: NetworkVertex = null :
	set(vert):
		selected_vert = vert
		for v in vert_list:
			v.selected = (v == vert)
			v.queue_redraw()


func init_lists() -> void:
	edge_list.clear()
	vert_list.clear()
	edge_list.append_array($Edges.get_children().filter(func(n): return n is NetworkEdge))
	vert_list.append_array($Vertices.get_children().filter(func(n): return n is NetworkVertex))

func editor_redraw() -> void:
	if Engine.is_editor_hint():
		for edge in edge_list: edge.editor_redraw()
		for vert in vert_list: vert.editor_redraw()

func color_start_adjacent() -> void:
	if Engine.is_editor_hint(): init_lists()
	for edge in edge_list:
		edge.color = Color.WHITE if edge.has_vertex(start_vertex) else Color.DARK_SLATE_GRAY
		edge.queue_redraw()
	for vert in vert_list:
		if vert == start_vertex:
			vert.color = Color.ORANGE
		else:
			vert.color = Color.WHITE if verts_are_adjacent(vert, start_vertex) else Color.DARK_SLATE_GRAY
		vert.queue_redraw()

func _ready() -> void:
	init_lists()
	for vert in vert_list:
		vert.lclicked.connect(_on_vertex_lclicked)
		vert.rclicked.connect(_on_vertex_rclicked)
	color_start_adjacent()

func _process(_delta: float) -> void:
	editor_redraw()

func verts_are_adjacent(vert1, vert2) -> bool:
	for edge in edge_list:
		if edge.has_vertices(vert1, vert2): return true
	return false

func _on_vertex_lclicked(vert) -> void:
	selected_vert = vert

func _on_vertex_rclicked(vert) -> void:
	start_vertex = vert # TESTING
