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
	PlayerData.reset()
	ContractManager.reset_active_contracts()
	connect_signals()
	# Reinitialize map stuff to sync camera
	map_display.network_map.start_vertex = map_display.network_map.start_vertex
	map_display.network_map.selected_vertex = map_display.network_map.selected_vertex
	# Initialize labels
	location_display.value = map_display.network_map.start_vertex.location_name
	day_display.value = str(PlayerData.moves_remaining)
	debt_display.value = str(PlayerData.debt_remaining)
	update_cargo_details()

func _input(event):
	if event.is_action_pressed("travel") and not travel_button.disabled:
		_on_travel_button_pressed()

func connect_signals() -> void:
	ContractManager.active_contracts_modified.connect(_on_contract_manager_active_contracts_modified)
	ContractManager.contract_accepted.connect(_on_contract_manager_contract_accepted)
	ContractManager.contract_completed.connect(_on_contract_manager_contract_completed)
	PlayerData.moves_updated.connect(_on_moves_updated)
	PlayerData.debt_updated.connect(_on_debt_updated)
	travel_button.pressed.connect(_on_travel_button_pressed)
	map_display.selected_vertex_changed.connect(_on_selected_vertex_changed)
	# Camera control signals
	location_contracts.contract_show_destination_button_down.connect(set_temporary_camera_vertex)
	location_contracts.contract_show_destination_button_up.connect(set_temporary_camera_vertex)
	player_contracts.contract_show_destination_button_down.connect(set_temporary_camera_vertex)
	player_contracts.contract_show_destination_button_up.connect(set_temporary_camera_vertex)


# MAP CONTROL ------------------------------------------------------------------
func set_temporary_camera_vertex(vertex : NetworkVertex = null) -> void:
	if vertex != null:
		camera_recall_position = map_display.camera.global_position
		map_display.move_camera_to_vertex(vertex)
	else:
		map_display.move_camera_to_position(camera_recall_position)

func map_move_to_selection() -> void:
	map_display.network_map.set_start_selected()
	PlayerData.take_move()


# UI CONTROL -------------------------------------------------------------------
func reset_travel_button() -> void:
	travel_button.disabled = true

func set_day_display(days : int) -> void:
	day_display.value = str(days)

func set_debt_display(debt : int) -> void:
	debt_display.value = str(debt)

func update_cargo_details() -> void:
	var space_used : String = str(ContractManager.get_total_active_space_used())
	var total_space : String = str(PlayerData.starting_space)
	var cargo_space_details : String = space_used + " / " + total_space + " cu. ft."
	player_contracts.set_detail_text(cargo_space_details)

func update_location_contracts(vertex : NetworkVertex) -> void:
	var start_vertex_selected : bool = (map_display.network_map.start_vertex == vertex)
	var contracts = ContractManager.get_location_contracts(vertex)
	location_contracts.repopulate_list(contracts, false, not start_vertex_selected)


# MAP SIGNALS ------------------------------------------------------------------
func _on_travel_button_pressed() -> void:
	reset_travel_button()
	map_move_to_selection()
	var start_vertex = map_display.network_map.start_vertex
	update_location_contracts(start_vertex)
	location_display.value = start_vertex.location_name
	player_contracts.poll_for_completion(start_vertex)

## Control travel button's disabled state and update the location contract list
func _on_selected_vertex_changed(vertex : NetworkVertex, adjacent : bool) -> void:
	travel_button.disabled = not adjacent
	update_location_contracts(vertex)
	#location_display.value = vertex.location_name # Set when travelling instead
	location_contracts.set_detail_text(vertex.location_name)


# UI SIGNALS -------------------------------------------------------------------
func _on_moves_updated(moves) -> void:
	set_day_display(moves)

func _on_debt_updated(debt) -> void:
	set_debt_display(debt)


# MANAGER SIGNALS --------------------------------------------------------------
func _on_contract_manager_contract_accepted(contract : ContractData) -> void:
	player_contracts.add_contract_entry(contract, true, false)

func _on_contract_manager_contract_completed(contract : ContractData) -> void:
	PlayerData.reduce_debt(contract.reward)

func _on_contract_manager_active_contracts_modified() -> void:
	location_contracts.refresh_list_disabled_state()
	update_cargo_details()
