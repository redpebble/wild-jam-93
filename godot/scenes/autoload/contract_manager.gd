extends Node

var locations : Dictionary[NetworkVertex, Array] = {}


func add_location(vertex : NetworkVertex) -> void:
	locations[vertex] = []
	for i in 2:
		locations[vertex].append(generate_contract(vertex))

# FIXME: Hardcoded data for testing, make dynamic
func generate_contract(_vertex : NetworkVertex) -> ContractData:
	var data = ContractData.new()
	var distance : int = randi_range(1, 3) # FIXME: cap at furthest vertex distance
	data.destination = "Stationary Hill" # traverse network
	data.size = randi_range(10, 100) * 10 # 100 - 1000
	data.reward = data.size * distance
	return data

func get_location_contracts(vertex : NetworkVertex) -> Array:
	return locations[vertex]
