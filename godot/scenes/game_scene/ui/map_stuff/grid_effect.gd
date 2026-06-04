@tool
extends ColorRect


func _ready() -> void:
	resized.connect(_on_resized)

func _on_resized() -> void:
	$GridSprite.position = size * 0.5
	$GridSprite.region_rect.end = size
