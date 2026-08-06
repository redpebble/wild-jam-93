extends Node

@onready var music_player: MusicLooper = %MusicPlayer

@export var music_loops : Dictionary[String, MusicLoop] = {
	"main_menu" : null,
	"game" : null
}

var music_dampened : bool = false : set = set_music_dampened

func _ready() -> void:
	connect_web_signals()

func connect_web_signals() -> void:
	if OS.has_feature("web"):
		get_window().focus_entered.connect(_on_window_focus_entered)
		get_window().focus_exited.connect(_on_window_focus_exited)

# PLAYBACK CONTROL -------------------------------------------------------------
func play_music(music_name : String) -> void:
	reset_volume()
	var music = music_loops.get(music_name)
	if !music:
		push_warning("No music found with name ", music_name, ".")
	music_player.music_loop = music
	music_player.restart()


# VOLUME CONTROL ---------------------------------------------------------------
func fade_out() -> void:
	music_player.fade_volume_to_linear_value(0.0)

func fade_in() -> void:
	music_player.fade_volume(1.0)

func reset_volume() -> void:
	music_player.reset_volume()


# EFFECT CONTROL ---------------------------------------------------------------
func set_music_dampened(state : bool) -> void:
	music_dampened = state
	_set_music_lowpass_enabled(music_dampened)

func _set_music_lowpass_enabled(enabled : bool) -> void:
	var music_bus_idx = AudioServer.get_bus_index("Music")
	var effect_idx : int = 0
	AudioServer.set_bus_effect_enabled(music_bus_idx, effect_idx, enabled)


# UTILITY ----------------------------------------------------------------------
func get_current_music_name() -> String:
	var current_music_loop = music_player.music_loop
	var music_name := ""
	if music_loops.values().has(current_music_loop):
		music_name = music_loops.find_key(current_music_loop)
	return music_name


# WEB SIGNALS ------------------------------------------------------------------
func _on_window_focus_entered() -> void:
	music_player.stream_paused = false

func _on_window_focus_exited() -> void:
	music_player.stream_paused = true
