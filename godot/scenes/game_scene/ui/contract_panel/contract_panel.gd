@tool
extends PanelContainer

@export var header_text : String = "Header" : set = set_header_text

@onready var header: Label = %Header

func set_header_text(text : String) -> void:
	header_text = text
	%Header.text = header_text
