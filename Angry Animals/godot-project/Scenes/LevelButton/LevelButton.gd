extends TextureButton


@export var level_number 	: int = 1

@onready var level			: Label = $VContainer/Level
@onready var attempts		: Label = $VContainer/Attempts


func _ready() -> void:
	level.text = "%d" % level_number
	attempts.text = "%d" % ScoreManager.get_level_best(level_number)


func _on_mouse_entered() -> void:
	scale = Vector2(1.1, 1.1)


func _on_mouse_exited() -> void:
	scale = Vector2(1, 1)


func _on_pressed() -> void:
	ScoreManager.level_selected = level_number
	get_tree().change_scene_to_file(
		"res://Scenes/LevelBase/Level%d.tscn" % level_number
		)
