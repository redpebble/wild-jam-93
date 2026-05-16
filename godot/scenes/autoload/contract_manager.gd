extends Node

var map_contracts : Dictionary[NetworkVertex, Array] = {}
var network_map : NetworkMap = null :
	set(_network_map):
		network_map = _network_map
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
	var destination_name = destination_vertex.location_name
	data.destination = destination_name
	# TODO: Make distance based on edge count
	var distance = destination_vertex.global_position.distance_squared_to(vertex.global_position)
	data.size = randi_range(1, 4) * 100
	data.reward = data.size * round(distance / 10000) # just messing 
	return data

func get_location_contracts(vertex : NetworkVertex) -> Array:
	return map_contracts[vertex]
