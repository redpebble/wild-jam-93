class_name ContractEntry
extends PanelContainer

signal cancelled
signal accepted

@export var in_progress : bool = false : set = set_in_progress

@onready var message_container: PanelContainer = %MessageContainer
@onready var message: Label = %Message

# INTERFACE
@onready var cancel: Button = %Cancel
@onready var accept: Button = %Accept

# DATA FIELDS
@onready var destination: Label = %Destination
@onready var details: Label = %Details
@onready var reward: Label = %Reward

var disabled : bool = false : set = set_disabled

func set_in_progress(state : bool) -> void:
	in_progress = state
	cancel.visible = in_progress
	accept.visible = not in_progress
	cancel.pressed.connect(_on_cancel_pressed)
	accept.pressed.connect(_on_accept_pressed)

func set_disabled(state : bool) -> void:
	disabled = state
	cancel.disabled = disabled
	accept.disabled = disabled

func match_data(data : ContractData) -> void:
	destination.text = data.destination
	reward.text = "$" + str(data.reward)
	details.text = str(data.size) + " cu. ft."

func _on_cancel_pressed() -> void:
	cancelled.emit()
	show_message("CANCELLED", Color.CRIMSON)

func _on_accept_pressed() -> void:
	accepted.emit()
	show_message("ACCEPTED", Color("31fbfb"))

func show_message(_text : String, color := Color.WHITE) -> void:
	message.text = _text
	message_container.modulate = color
	message_container.show()
