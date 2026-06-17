class_name TransitionOverlay
extends CanvasLayer

signal transition_in_completed
signal transition_out_completed

@export var transition_duration : float = 0.3

@onready var color_rect : ColorRect = $ColorRect

var _effect_tween : Tween = null

func _ready() -> void:
	color_rect.modulate.a = 0.0

func transition_in() -> void:
	await _tween_alpha_to(1.0).finished
	transition_in_completed.emit()

func transition_out() -> void:
	await _tween_alpha_to(0.0).finished
	transition_out_completed.emit()
	queue_free()

func _tween_alpha_to(a : float) -> Tween:
	if _effect_tween: _effect_tween.kill()
	_effect_tween = create_tween()
	_effect_tween.tween_property(color_rect, "modulate:a", a, transition_duration)
	return _effect_tween
