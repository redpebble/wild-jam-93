@tool
class_name MarginPercentageContainer
extends MarginContainer

@export_range(0, 1) var left : float = 0.0 :
	set(value):
		left = value
		set_margin("left", left)
@export_range(0, 1) var top : float = 0.0 :
	set(value):
		top = value
		set_margin("top", top)
@export_range(0, 1) var right : float = 0.0 :
	set(value):
		right = value
		set_margin("right", right)
@export_range(0, 1) var bottom : float = 0.0 :
	set(value):
		bottom = value
		set_margin("bottom", bottom)

func set_margin(side : String, value) -> void:
	var max = _get_corresponding_dimension(side) / 2
	var margin_size : int = lerp(0, max, get(side))
	add_theme_constant_override("margin_" + side, margin_size)

func _get_corresponding_dimension(side : String) -> int:
	match(side):
		"left", "right":
			return _get_max_dimensions().x
		"top", "bottom":
			return _get_max_dimensions().y
		_:
			return 0

func _get_max_dimensions() -> Vector2i:
	var max_x = ProjectSettings.get_setting("display/window/size/viewport_width")
	var max_y = ProjectSettings.get_setting("display/window/size/viewport_height")
	return Vector2(max_x, max_y)
