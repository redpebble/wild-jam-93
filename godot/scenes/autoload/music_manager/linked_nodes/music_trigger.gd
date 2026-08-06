class_name MusicTrigger
extends Node

@export var music_name : String = ""
@export var autoplay : bool = true

func _ready() -> void:
	if autoplay and music_name:
		if MusicManager.get_current_music_name() != music_name:
			MusicManager.play_music(music_name)
