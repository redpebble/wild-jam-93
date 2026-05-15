extends Node

var locations : Dictionary[NetworkVertex, Array] = {}
var network_map : NetworkMap = null :
	set(_network_map):
		network_map = _network_map
		for i : NetworkVertex in network_map.vertex_list:
			add_location(i)
		for i : NetworkVertex in network_map.vertex_list:
			assign_contracts(i, 3)


func add_location(vertex : NetworkVertex) -> void:
	locations[vertex] = []

func assign_contracts(vertex : NetworkVertex, max_count : int) -> void:
	var location_pool = locations.keys().duplicate(true)
	location_pool.erase(vertex)
	for i in locations[vertex]:
		location_pool.erase(i)
	for i in randi_range(1, max_count):
		if location_pool.is_empty():
			break
		# TODO: Make destination_vertex a neighbor within some edge count, maybe 1-4, favoring more
		# Select random other vertex and remove it from the pool
		location_pool.shuffle()
		var destination = location_pool.pop_back()
		locations[vertex].append(generate_contract(vertex, destination))

func generate_contract(vertex : NetworkVertex, destination_vertex : NetworkVertex) -> ContractData:
	var data = ContractData.new()
	var destination_name = destination_vertex.location_name
	data.destination = destination_name
	# TODO: Make distance based on edge count
	var distance = destination_vertex.global_position.distance_squared_to(vertex.global_position)
	data.size = randi_range(10, 100) * 100 # 100 - 1000
	data.reward = data.size * distance / 100000
	return data

func get_location_contracts(vertex : NetworkVertex) -> Array:
	return locations[vertex]
