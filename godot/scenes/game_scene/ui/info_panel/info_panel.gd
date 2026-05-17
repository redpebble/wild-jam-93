@tool
class_name InfoPanel
extends PanelContainer

@export var descriptor : String = "Descriptor" : set = set_descriptor
@export var value : String = "Value" : set = set_value
@export var value_prefix : String = "" : set = set_value_prefix
@export var value_suffix : String = "" : set = set_value_suffix
@export var label_settings : LabelSettings : set = set_label_settings

@onready var label : Label = $Label


func set_descriptor(text : String) -> void:
	descriptor = text
	update_label()

func set_value(text : String) -> void:
	value = text
	update_label()

func set_value_prefix(text : String) -> void:
	value_prefix = text
	update_label()
	
func set_value_suffix(text : String) -> void:
	value_suffix = text
	update_label()

func update_label() -> void:
	$Label.text = descriptor + " | " + value_prefix + value + value_suffix

func set_label_settings(settings : LabelSettings) -> void:
	label_settings = settings
	if not is_node_ready():
		await ready
	$Label.label_settings = label_settings
