class_name ContractEntry
extends PanelContainer

signal cancelled
signal accepted
signal show_destination_button_down(vertex : NetworkVertex)
signal show_destination_button_up()

@export var in_progress : bool = false : set = set_in_progress

@onready var message_container: PanelContainer = %MessageContainer
@onready var message: Label = %Message
@onready var data_container: HBoxContainer = $DataContainer

# INTERFACE
@onready var cancel: Button = %Cancel
@onready var accept: Button = %Accept
@onready var show_destination: Button = %ShowDestination

# DATA FIELDS
@onready var destination: Label = %Destination
@onready var details: Label = %Details
@onready var reward: Label = %Reward

var disabled : bool = false : set = set_disabled
var handled : bool = false # true after a message is shown
var data : ContractData = null : set = set_data

func set_in_progress(state : bool) -> void:
	in_progress = state
	cancel.visible = in_progress
	accept.visible = not in_progress
	cancel.pressed.connect(_on_cancel_pressed)
	accept.pressed.connect(_on_accept_pressed)
	show_destination.button_down.connect(_on_show_destination_button_down)
	show_destination.button_up.connect(_on_show_destination_button_up)

func set_disabled(state : bool) -> void:
	disabled = state
	cancel.disabled = disabled
	accept.disabled = disabled
	data_container.modulate.a = 0.5 if disabled else 1.0

func set_data(_data : ContractData) -> void:
	data = _data
	destination.text = data.get_destination_name()
	reward.text = "$$" + str(data.reward)
	details.text = str(data.size) + " cu. ft."

func _on_cancel_pressed() -> void:
	cancelled.emit()
	await show_message("CANCELLED", Color("crimson"))
	delete_entry()

func _on_accept_pressed() -> void:
	#if ContractManager.active_contracts.size() >= PlayerData.contract_limit: return 
	accepted.emit()
	await show_message("ACCEPTED", Color("31fbfb"))
	delete_entry()

func complete() -> void:
	PlayerData.reduce_debt(data.reward)
	await show_message("COMPLETE", Color("green"))
	ContractManager.remove_contract(data)
	delete_entry()

func _on_show_destination_button_down() -> void:
	show_destination_button_down.emit(data.destination)
	
func _on_show_destination_button_up() -> void:
	show_destination_button_up.emit()

func show_message(_text : String, color := Color("white")) -> void:
	handled = true
	message.text = _text
	message_container.modulate = color
	message_container.show()
	await get_tree().create_timer(0.5).timeout

func delete_entry() -> void:
	custom_minimum_size.y = size.y
	data_container.hide()
	var t = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	t.tween_property(self, "modulate:a", 0, 0.4)
	await t.finished
	#message_container.hide()
	#t = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	#t.tween_property(self, "custom_minimum_size:y", 0, 0.3)
	#await t.finished
	queue_free()
