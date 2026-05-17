@tool
extends "res://scenes/credits/scrolling_credits.gd"

## Defines the path to the main menu. Hides the Main Menu button if not set.
## Will attempt to read from AppConfig if left empty.
@export_file("*.tscn") var game_scene_path : String
## This option forces the mouse to be visible when the menu shows up.
## Useful for games that capture the mouse, and don't automatically return it.
@export var force_mouse_mode_visible : bool = false

@onready var end_message_panel = %EndMessagePanel
@onready var exit_button = %ExitButton
@onready var restart_button = %MenuButton
@onready var init_mouse_filter : MouseFilter = mouse_filter

func get_game_scene_path() -> String:
	if game_scene_path.is_empty():
		return AppConfig.game_scene_path
	return game_scene_path

func _end_reached() -> void:
	end_message_panel.show()
	mouse_filter = Control.MOUSE_FILTER_STOP
	if force_mouse_mode_visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	super._end_reached()

func reload_game() -> void:
	SceneLoader.load_scene(get_game_scene_path())

func exit_game() -> void:
	if OS.has_feature("web"):
		reload_game()
	get_tree().quit()

func _on_visibility_changed() -> void:
	if visible:
		end_message_panel.hide()
		mouse_filter = init_mouse_filter
	super._on_visibility_changed()

func _ready() -> void:
	if get_game_scene_path().is_empty():
		restart_button.hide()
	if OS.has_feature("web"):
		exit_button.hide()
	end_message_panel.hide()
	super._ready()

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		if not end_message_panel.visible:
			_end_reached()
		else:
			exit_game()

func _on_exit_button_pressed():
	exit_game()

func _on_menu_button_pressed():
	reload_game()
