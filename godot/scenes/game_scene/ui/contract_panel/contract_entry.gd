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

@warning_ignore("unused_parameter") # TODO: Remove when data is implemented
func match_data(data) -> void:
	#destination.text = data.destination
	#details.text = data.details
	#reward.text = data.reward
	pass
