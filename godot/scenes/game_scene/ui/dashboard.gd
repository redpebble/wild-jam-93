extends Control

@onready var travel_button: Button = %TravelButton
@onready var map_display: MapDisplay = %MapDisplay
@onready var player_contracts: PanelContainer = %PlayerContracts
@onready var location_contracts: ContractPanel = %LocationContracts


func _ready() -> void:
	travel_button.pressed.connect(_on_travel_button_pressed)
	map_display.selected_vertex_changed.connect(_on_selected_vertex_changed)
	reset_travel_button()

func _on_travel_button_pressed() -> void:
	map_display.network_map.set_start_selected()
	reset_travel_button()

## Control travel button's disabled state and update the location contract list
func _on_selected_vertex_changed(vertex : NetworkVertex, adjacent : bool) -> void:
	travel_button.disabled = not adjacent
	#print(ContractManager.get_location_contracts(vertex))
	location_contracts.populate_list(ContractManager.get_location_contracts(vertex))

func reset_travel_button() -> void:
	travel_button.disabled = true
