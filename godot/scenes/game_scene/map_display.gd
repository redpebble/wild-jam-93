class_name MapDisplay
extends Node2D

signal selected_vertex_changed(vertex : NetworkVertex, adjacent : bool)

@onready var network_map : NetworkMap = $NetworkMap
@onready var camera = $InteractiveCamera
@onready var map_controls = $Overlay/MapControls


func _ready() -> void:
	network_map.start_vertex_changed.connect(_on_start_vertex_changed)
	network_map.selected_vertex_changed.connect(_on_selected_vertex_changed)
	map_controls.zoom_in_pressed.connect(zoom_camera_in)
	map_controls.zoom_out_pressed.connect(zoom_camera_out)
	map_controls.refocus_pressed.connect(refocus_camera)

func _on_start_vertex_changed(_vertex : NetworkVertex) -> void:
	refocus_camera()

func _on_selected_vertex_changed(vertex : NetworkVertex, adjacency : bool) -> void:
	selected_vertex_changed.emit(vertex, adjacency)

func refocus_camera() -> void:
	camera.move_to(network_map.start_vertex.global_position)

func zoom_camera_in() -> void:
	camera.zoom_by(camera.zoom_increment * 2)
	
func zoom_camera_out() -> void:
	camera.zoom_by(-camera.zoom_increment * 2)


func _on_travel_button_pressed() -> void:
	network_map.set_start_selected()
