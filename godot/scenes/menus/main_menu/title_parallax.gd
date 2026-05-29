extends Node2D

@onready var original: Node2D = $Original
@onready var origin = original.position

@export var falloff : Curve
@export var duplicates : int = 8

var settle_speed : float = 4


func _ready() -> void:
	for i in duplicates:
		var new_depth = original.duplicate()
		var scale_reduction = Vector2.ONE * (0.02 * (i + 1))
		var falloff_level = falloff.sample(inverse_lerp(0, duplicates - 1, i))
		new_depth.scale = original.scale - scale_reduction
		new_depth.modulate = original.modulate.darkened(falloff_level)
		new_depth.z_index -= i + 1
		call_deferred_thread_group("add_child", new_depth)

func _process(delta: float) -> void:
	var mouse_pos : Vector2 = get_global_mouse_position()
	var measure_pos : Vector2 = get_viewport_rect().size * Vector2(0.5, -1)
	var center_to_mouse : Vector2 = mouse_pos - measure_pos
	for i in get_children():
		var offset = center_to_mouse * 0.005 * i.get_index()
		i.position = lerp(i.position, origin + offset, settle_speed * delta)
