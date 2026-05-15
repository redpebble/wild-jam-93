extends VBoxContainer

@export var contract_entry_scene : PackedScene


func _ready() -> void:
	for i in 4:
		add_contract_entry("place data here") # Replace string with actual data

func add_contract_entry(data) -> void:
	var c : ContractEntry = contract_entry_scene.instantiate()
	call_deferred_thread_group("add_child", c)
	await c.ready
	c.match_data(data)
	c.in_progress = false # for testing
