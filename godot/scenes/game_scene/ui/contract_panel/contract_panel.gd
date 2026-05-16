@tool
class_name ContractPanel
extends PanelContainer

@export var header_text : String = "Header" : set = set_header_text

@onready var header : Label = %Header
@onready var contract_list : VBoxContainer = %ContractList

var contract_entry_scene : PackedScene = preload("uid://uliove6dy53")


func set_header_text(text : String) -> void:
	header_text = text
	%Header.text = header_text

func repopulate_list(contracts : Array, in_progress := false, disabled := false) -> void:
	clear_list()
	for i in contracts:
		add_contract_entry(i, in_progress, disabled)

func add_contract_entry(data : ContractData, in_progress := false, disabled := false) -> void:
	var c : ContractEntry = contract_entry_scene.instantiate()
	contract_list.call_deferred_thread_group("add_child", c)
	await c.ready
	c.data = data
	c.in_progress = in_progress
	c.disabled = disabled

func clear_list() -> void:
	for i in contract_list.get_children():
		i.queue_free()
