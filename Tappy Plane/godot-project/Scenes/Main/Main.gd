extends Control


@onready var high_score_counter: Label = $Container/HighScoreCounter


func _ready() -> void:
	high_score_counter.text = "%04d" % GameManager.high_score


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("power"):
		GameManager.load_game_scene()
