extends Control

@onready var pause_screen		: CanvasLayer		= $PauseScreen
@onready var game_over_screen	: CanvasLayer		= $GameOverScreen

func _ready() -> void:
	GlobalSignalBus.player_died.connect(_on_player_died)

func _on_player_died() -> void:
	get_tree().paused        = true
	game_over_screen.visible = true

func _on_pause_button_pressed() -> void:
	get_tree().paused       = true
	pause_screen.visible    = true
	
