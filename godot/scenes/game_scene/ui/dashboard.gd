extends Control

@onready var travel_button: Button = %TravelButton
@onready var map_display: MapDisplay = %MapDisplay
@onready var player_contracts: PanelContainer = %PlayerContracts
@onready var location_contracts: ContractPanel = %LocationContracts
@onready var location_display: InfoPanel = %LocationDisplay

@onready var day_display: InfoPanel = %DayDisplay
@onready var debt_display: InfoPanel = %DebtDisplay

func _ready() -> void:
	travel_button.pressed.connect(_on_travel_button_pressed)
	map_display.selected_vertex_changed.connect(_on_selected_vertex_changed)
	reset_travel_button()
	_on_selected_vertex_changed(map_display.network_map.selected_vertex, false)

	day_display.value = str(PlayerData.starting_moves)
	debt_display.value = str(PlayerData.starting_debt)
	PlayerData.moves_updated.connect(_on_moves_updated)
	PlayerData.debt_updated.connect(_on_debt_updated)

func _on_travel_button_pressed() -> void:
	map_display.network_map.set_start_selected()
	PlayerData.moves_remaining -= 1
	reset_travel_button()
	update_location_contracts(map_display.network_map.start_vertex)

## Control travel button's disabled state and update the location contract list
func _on_selected_vertex_changed(vertex : NetworkVertex, adjacent : bool) -> void:
	travel_button.disabled = not adjacent
	update_location_contracts(vertex)
	location_display.value = vertex.location_name

func update_location_contracts(vertex : NetworkVertex) -> void:
	var start_vertex_selected : bool = (map_display.network_map.start_vertex == vertex)
	var contracts = ContractManager.get_location_contracts(vertex)
	location_contracts.repopulate_list(contracts, false, not start_vertex_selected)

func reset_travel_button() -> void:
	travel_button.disabled = true

func _on_moves_updated(moves) -> void:
	day_display.value = str(moves)

func _on_debt_updated(debt) -> void:
	debt_display.value = str(debt)
