class_name ContractEntry
extends PanelContainer

@export var in_progress : bool = false : set = set_in_progress

# INTERFACE
@onready var cancel: Button = %Cancel
@onready var accept: Button = %Accept

# DATA FIELDS
@onready var destination: Label = %Destination
@onready var details: Label = %Details
@onready var reward: Label = %Reward


func set_in_progress(state : bool) -> void:
	in_progress = state
	cancel.visible = in_progress
	accept.visible = not in_progress
	cancel.pressed.connect(_on_cancel_pressed)
	accept.pressed.connect(_on_accept_pressed)

func match_data(data : ContractData) -> void:
	destination.text = data.destination
	reward.text = str(data.reward)
	#size.text = data.size # TODO: Account for this in some way
	#details.text = data.details

func _on_cancel_pressed() -> void:
	pass

func _on_accept_pressed() -> void:
	pass
