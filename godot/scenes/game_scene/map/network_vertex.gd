@tool
class_name NetworkVertex
extends Area2D

signal lclicked(vertex)
signal rclicked(vertex)


@onready var location_label: Label = %LocationLabel

@export var location_name : String = ""
@export var radius: float = 15.0 :
	set(val):
		radius = val
		$CollisionShape2D.shape.radius = radius * 1.5
		queue_redraw()
@export var highlight_color : Color

var color: Color = Color.WHITE

var selected: bool = false
var hovered: bool  = false : set = set_hovered


func editor_redraw() -> void:
	if Engine.is_editor_hint(): queue_redraw()

func _draw() -> void:
	if hovered:
		var collision_r = $CollisionShape2D.shape.radius
		draw_circle(Vector2.ZERO, collision_r, highlight_color, true, -1, true)
	if selected:
		draw_circle(Vector2.ZERO, radius + 5, Color.WHITE, false, 1, true)
	draw_circle(Vector2.ZERO, radius, color, true, -1, true)

func _ready() -> void:
	if Engine.is_editor_hint(): return
	mouse_entered.connect(set_hovered.bind(true))
	mouse_exited.connect(set_hovered.bind(false))
	location_label.text = location_name
	location_label.hide()

func _process(_delta: float) -> void:
	editor_redraw()

func set_hovered(state : bool) -> void:
	hovered = state
	location_label.visible = hovered
	queue_redraw()


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not (event is InputEventMouseButton and event.is_pressed()): return
	if event.button_index == 1: lclicked.emit(self)
	if event.button_index == 2: rclicked.emit(self)
