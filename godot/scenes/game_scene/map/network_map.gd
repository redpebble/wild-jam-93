class_name NetworkMap
extends Node

@export var start_vertex: NetworkVertex

@onready var edges: Array[Node] = $Edges.get_children()

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
