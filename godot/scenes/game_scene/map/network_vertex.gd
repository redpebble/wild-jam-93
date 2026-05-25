@tool
class_name NetworkVertex
extends Area2D

signal lclicked(vertex)
signal rclicked(vertex)
signal highlight_state_changed(state)

@export var location_name : String :
	set(val):
		location_name = val

@export var radius: float = 15.0 :
	set(val):
		radius = val
		$CollisionShape2D.shape.radius = radius * 1.5
		queue_redraw()
@export var highlight_color : Color

var color: Color = Color.WHITE

var selected: bool = false
var highlighted: bool  = false : set = set_highlighted
var highlight_override: bool = false : set = set_highlight_override

func editor_redraw() -> void:
	if Engine.is_editor_hint(): queue_redraw()

func _draw() -> void:
	if highlighted or highlight_override:
		var collision_r = $CollisionShape2D.shape.radius
		draw_circle(Vector2.ZERO, collision_r, highlight_color, true, -1, true)
	if selected:
		draw_circle(Vector2.ZERO, radius + 5, Color.WHITE, false, 1, true)
	draw_circle(Vector2.ZERO, radius, color, true, -1, true)

func _ready() -> void:
	if Engine.is_editor_hint(): return
	mouse_entered.connect(set_highlighted.bind(true))
	mouse_exited.connect(set_highlighted.bind(false))

func _process(_delta: float) -> void:
	editor_redraw()

func set_highlighted(state : bool) -> void:
	highlighted = state
	highlight_state_changed.emit(state)
	queue_redraw()

func set_highlight_override(state: bool) -> void:
	highlight_override = state
	queue_redraw()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not (event is InputEventMouseButton and event.is_pressed()): return
	if event.button_index == 1: lclicked.emit(self)
	if event.button_index == 2: rclicked.emit(self)
