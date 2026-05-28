@tool
class_name ContractPanel
extends PanelContainer

signal contract_show_destination_button_down(vertex : NetworkVertex)
signal contract_show_destination_button_up()

@export var header_text : String = "Header" : set = set_header_text

@onready var header : Label = %Header
@onready var details: Label = %Details
@onready var contract_list : VBoxContainer = %ContractList

var contract_entry_scene : PackedScene = preload("uid://uliove6dy53")
var available_contracts : Array[ContractData] = [] # NOT redundant; lets the UI animate


func set_header_text(text : String) -> void:
	header_text = text
	%Header.text = header_text

func set_detail_text(text : String) -> void:
	details.text = text

func repopulate_list(contracts : Array, in_progress : bool, disabled := false) -> void:
	clear_list()
	for c : ContractData in contracts:
		var entry = await add_contract_entry(c, in_progress, disabled)
		available_contracts.append(c)
		refresh_entry_disabled_state(entry, disabled)

func add_contract_entry(data : ContractData, in_progress : bool, disabled := false) -> ContractEntry:
	var c : ContractEntry = contract_entry_scene.instantiate()
	contract_list.call_deferred_thread_group("add_child", c)
	await c.ready
	c.data = data
	c.in_progress = in_progress
	c.disabled = disabled
	c.cancelled.connect(_on_contract_cancelled.bind(data))
	c.accepted.connect(_on_contract_accepted.bind(data))
	c.show_destination_button_down.connect(_on_contract_show_destination_button_down)
	c.show_destination_button_up.connect(_on_contract_show_destination_button_up)
	return c

func refresh_entry_disabled_state(entry : ContractEntry, force_disabled := false) -> void:
	if not entry.in_progress:
		entry.beyond_capacity = entry.data.size > PlayerData.get_remaining_space()
		entry.disabled = entry.beyond_capacity
	if force_disabled:
		entry.disabled = true

func refresh_list_disabled_state(force_disabled := false) -> void:
	for entry in contract_list.get_children():
		# skip entries that are displaying a message on their way to deletion
		if entry.handled:
			continue
		refresh_entry_disabled_state(entry, force_disabled)

func clear_list() -> void:
	available_contracts.clear()
	for i in contract_list.get_children():
		i.queue_free()

func poll_for_completion(vertex : NetworkVertex) -> void:
	for entry : ContractEntry in contract_list.get_children():
		var contract = entry.data
		if contract.destination.location_name == vertex.location_name:
			entry.complete()
			available_contracts.erase(contract)
			ContractManager.complete_contract(contract)


# SIGNALS ----------------------------------------------------------------------
func _on_contract_cancelled(contract : ContractData) -> void:
	available_contracts.erase(contract)
	ContractManager.remove_contract(contract)

func _on_contract_accepted(contract : ContractData) -> void:
	available_contracts.erase(contract)
	ContractManager.accept_contract(contract)
	refresh_list_disabled_state()

func _on_contract_show_destination_button_down(vertex : NetworkVertex) -> void:
	contract_show_destination_button_down.emit(vertex)
	
func _on_contract_show_destination_button_up() -> void:
	contract_show_destination_button_up.emit()
