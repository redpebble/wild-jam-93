class_name MapDisplay
extends Node2D

signal selected_vertex_changed(vertex : NetworkVertex, adjacent : bool)

@onready var network_map : NetworkMap = $NetworkMap
@onready var camera : InteractiveCamera = $InteractiveCamera
@onready var map_controls = $Overlay/MapControls
@onready var location_label: LocationLabel = %LocationLabel



func _ready() -> void:
	network_map.start_vertex_changed.connect(_on_start_vertex_changed)
	network_map.selected_vertex_changed.connect(_on_selected_vertex_changed)
	network_map.highlighted_vertex_changed.connect(_on_highlighted_vertex_changed)
	map_controls.refocus_pressed.connect(refocus_camera)
	map_controls.zoom_slider_value_changed.connect(set_camera_zoom_percent)
	camera.zoom_scale_changed.connect(_on_camera_zoom_scale_changed)

func _process(_delta: float) -> void:
	if camera.is_zooming():
		location_label.set_offset_scale(camera.get_zoom_scale())


# CAMERA CONTROL ---------------------------------------------------------------
func refocus_camera() -> void:
	camera.move_to(network_map.start_vertex.global_position)

func move_camera_to_vertex(vertex : NetworkVertex, temporary := false) -> void:
	camera.move_to(vertex.global_position, temporary)

func set_camera_zoom_percent(percent : float) -> void:
	camera.set_zoom_toward_mouse(false)
	camera.zoom_percent = percent

func move_camera_to_recall_position() -> void:
	camera.move_to_recall_position()


# SIGNALS ----------------------------------------------------------------------
func _on_start_vertex_changed(_vertex : NetworkVertex) -> void:
	refocus_camera()

func _on_selected_vertex_changed(vertex : NetworkVertex, adjacent : bool) -> void:
	selected_vertex_changed.emit(vertex, adjacent)

func _on_highlighted_vertex_changed(vertex : NetworkVertex) -> void:
	location_label.set_linked_location(vertex)

func _on_travel_button_pressed() -> void:
	network_map.set_start_selected()

func _on_camera_zoom_scale_changed(value : float) -> void:
	map_controls.silent_set_zoom_slider_value(value)
