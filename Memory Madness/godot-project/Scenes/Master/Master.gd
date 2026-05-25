extends Control

@onready var main			: Control = $Main
@onready var game			: Control = $Game


func _ready() -> void:
	SignalHub.level_selected.connect(_on_level_selected)
	SignalHub.game_exit_pressed.connect(_on_game_exit_pressed)
	show_game(false)
	

func _on_level_selected(_level_setting: LevelSetting) -> void:
	show_game(true) 


func show_game(game_visibility: bool) -> void: 
	game.visible = game_visibility
	main.visible = !game_visibility


func _on_game_exit_pressed() -> void: 
	show_game(false)
