extends Node

signal contract_accepted
signal contract_completed
signal active_contracts_modified

var map_contracts : Dictionary[NetworkVertex, Array] = {}
var active_contracts : Array[ContractData] = []
var network_map : NetworkMap = null :
	set(_network_map):
		network_map = _network_map
		map_contracts.clear()
		for i : NetworkVertex in network_map.vertex_list:
			add_location(i)
		for i : NetworkVertex in network_map.vertex_list:
			assign_contracts(i, 3)


func add_location(vertex : NetworkVertex) -> void:
	map_contracts[vertex] = []

func assign_contracts(vertex : NetworkVertex, max_count : int) -> void:
	var location_pool = map_contracts.keys().duplicate(true)
	location_pool.erase(vertex)
	for i in map_contracts[vertex]:
		location_pool.erase(i)
	for i in randi_range(1, max_count):
		if location_pool.is_empty():
			break
		# TODO: Make destination_vertex a neighbor within some edge count, maybe 1-4 favoring more
		# Select random other vertex and remove it from the pool
		location_pool.shuffle()
		var destination = location_pool.pop_back()
		map_contracts[vertex].append(generate_contract(vertex, destination))

func generate_contract(vertex : NetworkVertex, destination_vertex : NetworkVertex) -> ContractData:
	var data = ContractData.new()
	data.origin = vertex
	data.destination = destination_vertex
	# TODO: Make distance based on edge count
	var distance = destination_vertex.global_position.distance_to(vertex.global_position)
	data.size = randi_range(1, 4) * 100
	data.reward = data.size * round(distance * 0.05) # just messing 
	return data

func get_location_contracts(vertex : NetworkVertex) -> Array:
	return map_contracts[vertex]

func accept_contract(contract : ContractData) -> void:
	map_contracts[contract.origin].erase(contract)
	active_contracts.append(contract)
	contract_accepted.emit(contract)
	active_contracts_modified.emit()

func remove_contract(contract : ContractData) -> void:
	active_contracts.erase(contract)
	active_contracts_modified.emit()

func complete_contract(contract : ContractData) -> void:
	active_contracts.erase(contract)
	contract_completed.emit(contract)
	active_contracts_modified.emit()

func get_total_active_space_used() -> int:
	var total_space : int = 0
	for c in active_contracts:
		total_space += c.size
	return total_space
