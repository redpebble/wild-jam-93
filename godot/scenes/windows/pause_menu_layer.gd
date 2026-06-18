extends CanvasLayer

@onready var pause_menu = %PauseMenu

func _ready():
	pause_menu.hidden.connect(_on_pause_menu_hidden)
	visibility_changed.connect(_on_visibility_changed)

func _on_pause_menu_hidden():
	hide()

func _on_visibility_changed():
	if visible:
		pause_menu.show()
