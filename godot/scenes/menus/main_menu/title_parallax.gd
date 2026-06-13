extends Node2D

@onready var original: Node2D = $Original
@onready var origin = original.position

@export var falloff : Curve
@export var duplicate_count : int = 200
@export var effect_cycle_point : int = 20

var duplicates : Array[Node2D] = []
var settle_speed : float = 4
var effect_idx = -1 :
	set(value):
		effect_idx = value
		for i in duplicates.size():
			var new_modulate = Color.BLACK
			if i % effect_cycle_point == effect_idx:
				var effect_intensity = i / float(duplicate_count)
				new_modulate = Color.WHITE #* 1.0 - effect_intensity
			var falloff_level = falloff.sample(inverse_lerp(0, duplicate_count - 1, i))
			duplicates[i].modulate = new_modulate.darkened(falloff_level)

func _ready() -> void:
	for i in duplicate_count:
		var new_depth = original.duplicate()
		var scale_reduction = Vector2.ONE * (0.005 * (i + 1))
		var falloff_level = falloff.sample(inverse_lerp(0, duplicate_count - 1, i))
		new_depth.scale = original.scale - scale_reduction
		new_depth.modulate = original.modulate.darkened(falloff_level)
		new_depth.z_index -= i + 1
		call_deferred_thread_group("add_child", new_depth)
		duplicates.append(new_depth)
	cycle_effect_idx()

func _process(delta: float) -> void:
	var mouse_pos : Vector2 = get_global_mouse_position()
	var measure_pos : Vector2 = get_viewport_rect().size * Vector2(0.5, -1)
	var center_to_mouse : Vector2 = mouse_pos - measure_pos
	for i in duplicates:
		var offset = center_to_mouse * 0.0002 * i.get_index()
		i.position = lerp(i.position, origin + offset, settle_speed * delta)

func cycle_effect_idx() -> void:
	if duplicate_count <= 0: return
	var max_idx = min(duplicate_count, effect_cycle_point)
	effect_idx = wrap(effect_idx + 1, 0, max_idx)
	get_tree().create_timer(0.033).timeout.connect(cycle_effect_idx)
