class_name ContractData
extends Resource

var origin : NetworkVertex = null
var destination : NetworkVertex = null
var details : String = ""
var reward : int = 0
var size : int = 0


func get_origin_name() -> String:
	return origin.location_name

func get_destination_name() -> String:
	return destination.location_name
