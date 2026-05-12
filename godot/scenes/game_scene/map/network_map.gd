class_name NetworkMap
extends Node

@onready var edges: Array[Node] = $Edges.get_children().filter(func(n): return n is NetworkEdge)

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
