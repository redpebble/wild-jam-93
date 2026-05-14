class_name MapDisplay
extends Node2D

@onready var network_map = $NetworkMap
@onready var camera = $InteractiveCamera

# TODO: Uncomment once start_vertex_changed signal is available
#func _ready() -> void:
	#network_map.start_vertex_changed.connect(_on_start_vertex_changed) 
#
#func _on_start_vertex_changed(_vertex : NetworkVertex) -> void:
	#refocus_camera()

func refocus_camera() -> void:
	camera.move_to(network_map.start_vertex.global_position)

func zoom_camera_in() -> void:
	camera.zoom_by(camera.zoom_increment * 2)
	
func zoom_camera_out() -> void:
	camera.zoom_by(-camera.zoom_increment * 2)
