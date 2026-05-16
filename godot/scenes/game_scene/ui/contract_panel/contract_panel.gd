@tool
class_name ContractPanel
extends PanelContainer

signal contract_show_destination_button_down(vertex : NetworkVertex)
signal contract_show_destination_button_up()

@export var header_text : String = "Header" : set = set_header_text

@onready var header : Label = %Header
@onready var contract_list : VBoxContainer = %ContractList

var contract_entry_scene : PackedScene = preload("uid://uliove6dy53")
var available_contracts : Array[ContractData] = []

func set_header_text(text : String) -> void:
	header_text = text
	%Header.text = header_text

func repopulate_list(contracts : Array, in_progress : bool, disabled := false) -> void:
	clear_list()
	for i : ContractData in contracts:
		add_contract_entry(i, in_progress, disabled)
		available_contracts.append(i)

func add_contract_entry(data : ContractData, in_progress : bool, disabled := false) -> void:
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

func clear_list() -> void:
	for i in contract_list.get_children():
		i.queue_free()


# SIGNALS ----------------------------------------------------------------------
func _on_contract_cancelled(contract : ContractData) -> void:
	available_contracts.erase(contract)
	ContractManager.cancel_contract(contract)

func _on_contract_accepted(contract : ContractData) -> void:
	available_contracts.erase(contract)
	ContractManager.accept_contract(contract)

func _on_contract_show_destination_button_down(vertex : NetworkVertex) -> void:
	contract_show_destination_button_down.emit(vertex)
	
func _on_contract_show_destination_button_up() -> void:
	contract_show_destination_button_up.emit()
