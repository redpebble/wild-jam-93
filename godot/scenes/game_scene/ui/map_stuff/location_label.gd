class_name LocationLabel
extends Node2D

const max_y_offset = -65
const min_y_offset = -40

@onready var label: Label = $Label

var linked_location : NetworkVertex = null : set = set_linked_location
var y_offset : float = -54 : set = set_y_offset

func _ready() -> void:
	hide()

func _process(_delta: float) -> void:
	if linked_location:
		match_location(linked_location)

func set_linked_location(vertex : NetworkVertex) -> void:
	linked_location = vertex
	if linked_location:
		match_location(vertex)
	visible = (linked_location != null)

func set_y_offset(value: float) -> void:
	y_offset = value
	label.position.y = y_offset

func match_location(vertex : NetworkVertex) -> void:
	label.text = vertex.location_name
	recenter_label()
	global_position = vertex.get_global_transform_with_canvas().origin

func recenter_label() -> void:
	label.size.x = 0
	label.position.x = -label.size.x / 2

func set_offset_scale(value: float) -> void:
	value = clamp(value, 0, 1)
	y_offset = lerp(min_y_offset, max_y_offset, value)
