@tool
class_name ContractPanel
extends PanelContainer

@export var header_text : String = "Header" : set = set_header_text

@onready var header : Label = %Header
@onready var contract_list : ContractList = %ContractList


func set_header_text(text : String) -> void:
	header_text = text
	%Header.text = header_text

func populate_list(contracts : Array) -> void:
	clear_list()
	for i in contracts:
		contract_list.add_contract_entry(i)

func clear_list() -> void:
	for i in contract_list.get_children():
		i.queue_free()
