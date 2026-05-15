extends Control

@onready var travel_button: Button = %TravelButton
@onready var map_display: MapDisplay = %MapDisplay


func _ready() -> void:
	travel_button.pressed.connect(_on_travel_button_pressed)
	map_display.selected_vertex_changed.connect(_on_selected_vertex_changed)
	reset_travel_button()

func _on_travel_button_pressed() -> void:
	map_display.network_map.set_start_selected()
	reset_travel_button()

func _on_selected_vertex_changed(_vertex : NetworkVertex, adjacency : bool) -> void:
	# Enable or disable travel depending on adjacency
	travel_button.disabled = not adjacency

func reset_travel_button() -> void:
	travel_button.disabled = true
