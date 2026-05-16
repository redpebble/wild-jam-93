extends Control

@onready var travel_button: Button = %TravelButton
@onready var map_display: MapDisplay = %MapDisplay
@onready var player_contracts: ContractPanel = %PlayerContracts
@onready var location_contracts: ContractPanel = %LocationContracts
@onready var location_display: InfoPanel = %LocationDisplay

@onready var day_display: InfoPanel = %DayDisplay
@onready var debt_display: InfoPanel = %DebtDisplay

var camera_recall_position := Vector2.ZERO


func _ready() -> void:
	ContractManager.contract_accepted.connect(_on_contract_manager_contract_accepted)
	travel_button.pressed.connect(_on_travel_button_pressed)
	map_display.selected_vertex_changed.connect(_on_selected_vertex_changed)
	reset_travel_button()
	_on_selected_vertex_changed(map_display.network_map.selected_vertex, false)

	day_display.value = str(PlayerData.starting_moves)
	set_debt_display(PlayerData.starting_debt)
	PlayerData.moves_updated.connect(_on_moves_updated)
	PlayerData.debt_updated.connect(_on_debt_updated)
	location_contracts.contract_show_destination_button_down.connect(set_temporary_camera_vertex)
	location_contracts.contract_show_destination_button_up.connect(set_temporary_camera_vertex)
	player_contracts.contract_show_destination_button_down.connect(set_temporary_camera_vertex)
	player_contracts.contract_show_destination_button_up.connect(set_temporary_camera_vertex)

func _input(event):
	if event.is_action_pressed("travel") and not travel_button.disabled:
		_on_travel_button_pressed()

func _on_travel_button_pressed() -> void:
	map_display.network_map.set_start_selected()
	PlayerData.take_move()
	reset_travel_button()
	var start_vertex = map_display.network_map.start_vertex
	update_location_contracts(start_vertex)
	player_contracts.poll_for_completion(start_vertex)

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

func set_temporary_camera_vertex(vertex : NetworkVertex = null) -> void:
	if vertex != null:
		camera_recall_position = map_display.camera.global_position
		map_display.move_camera_to_vertex(vertex)
	else:
		map_display.move_camera_to_position(camera_recall_position)

func set_debt_display(debt) -> void:
	debt_display.value = "$$"+str(debt)

func _on_moves_updated(moves) -> void:
	day_display.value = str(moves)

func _on_debt_updated(debt) -> void:
	set_debt_display(debt)

func _on_contract_manager_contract_accepted(contract : ContractData) -> void:
	player_contracts.add_contract_entry(contract, true, false)
