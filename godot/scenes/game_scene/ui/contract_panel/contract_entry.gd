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
var beyond_capacity : bool = false : set = set_beyond_capacity
var handled : bool = false
var data : ContractData = null : set = set_data

var delete_delay : float = 0.5
var fade_tween : Tween = null

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

func set_beyond_capacity(state : bool) -> void:
	beyond_capacity = state
	if beyond_capacity:
		details.modulate = Color("crimson")
	else:
		details.modulate = Color("white")

func set_data(_data : ContractData) -> void:
	data = _data
	destination.text = data.get_destination_name()
	reward.text = "$$ " + str(data.reward)
	details.text = str(data.size) + " cu. ft."

func _on_cancel_pressed() -> void:
	cancelled.emit()
	handle_with_message("CANCELLED", Color("crimson"))

func _on_accept_pressed() -> void:
	accepted.emit()
	handle_with_message("ACCEPTED", Color("31fbfb"))

func complete() -> void:
	ContractManager.remove_contract(data)
	handle_with_message("COMPLETE", Color("green"))

func handle_with_message(msg : String, color := Color("white")) -> void:
	handled = true
	show_message(msg, color)
	delete_entry()

func _on_show_destination_button_down() -> void:
	show_destination_button_down.emit(data.destination)
	
func _on_show_destination_button_up() -> void:
	show_destination_button_up.emit()

func show_message(_text : String, color := Color("white")) -> void:
	message.text = _text
	message_container.modulate = color
	message_container.show()

func hide_message() -> void:
	message_container.hide()

func delete_entry() -> void:
	await get_tree().create_timer(delete_delay).timeout
	# Preserve panel size then hide data
	custom_minimum_size.y = size.y
	data_container.hide()
	await fade_out().finished
	queue_free()

func fade_out() -> Tween:
	if fade_tween: fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	fade_tween.tween_property(self, "modulate:a", 0, 0.4)
	return fade_tween
