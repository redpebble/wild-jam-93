class_name MapDisplay
extends Node2D

signal selected_vertex_changed(vertex : NetworkVertex, adjacent : bool)

@onready var network_map : NetworkMap = $NetworkMap
@onready var camera = $InteractiveCamera
@onready var map_controls = $Overlay/MapControls
@onready var location_label: LocationLabel = %LocationLabel



func _ready() -> void:
	network_map.start_vertex_changed.connect(_on_start_vertex_changed)
	network_map.selected_vertex_changed.connect(_on_selected_vertex_changed)
	network_map.highlighted_vertex_changed.connect(_on_highlighted_vertex_changed)
	map_controls.zoom_in_pressed.connect(zoom_camera_in)
	map_controls.zoom_out_pressed.connect(zoom_camera_out)
	map_controls.refocus_pressed.connect(refocus_camera)

func _process(_delta: float) -> void:
	if camera.is_zooming():
		print(camera.get_zoom_scale())
		location_label.set_offset_scale(camera.get_zoom_scale())

# CAMERA CONTROL ---------------------------------------------------------------
func refocus_camera() -> void:
	camera.move_to(network_map.start_vertex.global_position)

func move_camera_to_vertex(vertex : NetworkVertex) -> void:
	camera.move_to(vertex.global_position)

func move_camera_to_position(pos : Vector2) -> void:
	camera.move_to(pos)

func zoom_camera_in() -> void:
	camera.zoom_by(camera.zoom_increment * 2)

func zoom_camera_out() -> void:
	camera.zoom_by(-camera.zoom_increment * 2)


# SIGNALS ----------------------------------------------------------------------
func _on_start_vertex_changed(_vertex : NetworkVertex) -> void:
	refocus_camera()

func _on_selected_vertex_changed(vertex : NetworkVertex, adjacent : bool) -> void:
	selected_vertex_changed.emit(vertex, adjacent)

func _on_highlighted_vertex_changed(vertex : NetworkVertex) -> void:
	location_label.set_linked_location(vertex)

func _on_travel_button_pressed() -> void:
	network_map.set_start_selected()
