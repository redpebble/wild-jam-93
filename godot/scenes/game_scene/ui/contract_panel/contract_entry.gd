class_name ContractEntry
extends PanelContainer

signal cancelled
signal accepted

@export var in_progress : bool = false : set = set_in_progress

@onready var message_container: PanelContainer = %MessageContainer
@onready var message: Label = %Message
@onready var data_container: HBoxContainer = $DataContainer

# INTERFACE
@onready var cancel: Button = %Cancel
@onready var accept: Button = %Accept

# DATA FIELDS
@onready var destination: Label = %Destination
@onready var details: Label = %Details
@onready var reward: Label = %Reward

var disabled : bool = false : set = set_disabled
var data : ContractData = null : set = set_data

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

func set_data(_data : ContractData) -> void:
	data = _data
	destination.text = data.get_destination_name()
	reward.text = "$" + str(data.reward)
	details.text = str(data.size) + " cu. ft."

func _on_cancel_pressed() -> void:
	cancelled.emit()
	show_message("CANCELLED", Color.CRIMSON)

func _on_accept_pressed() -> void:
	accepted.emit()
	await show_message("ACCEPTED", Color("31fbfb"))
	delete_entry()

func show_message(_text : String, color := Color.WHITE) -> void:
	message.text = _text
	message_container.modulate = color
	message_container.show()
	await get_tree().create_timer(0.4).timeout

func delete_entry() -> void:
	custom_minimum_size.y = size.y
	data_container.hide()
	var t = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	t.tween_property(self, "modulate:a", 0, 0.3)
	await t.finished
	message_container.hide()
	t.stop()
	t.tween_property(self, "custom_minimum_size:y", 0, 0.3)
	await t.finished
	queue_free()
