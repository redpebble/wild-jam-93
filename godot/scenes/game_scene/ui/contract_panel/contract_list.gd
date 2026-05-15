class_name ContractList
extends VBoxContainer

@export var contract_entry_scene : PackedScene


func add_contract_entry(data : ContractData) -> void:
	var c : ContractEntry = contract_entry_scene.instantiate()
	call_deferred_thread_group("add_child", c)
	await c.ready
	c.match_data(data)
	c.in_progress = false # for testing
