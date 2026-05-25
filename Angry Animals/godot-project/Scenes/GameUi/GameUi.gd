extends Control


const MAIN 							= preload("uid://bd1cp2il07ysw")

@onready var music						: AudioStreamPlayer = $Music
@onready var level_complete				: VBoxContainer = $LevelComplete
@onready var attempts_number			: Label = $MContainer/VContainer/HContainer2/AttemptsNumber
@onready var level_number				: Label = $MContainer/VContainer/HContainer/LevelNumber

var _total_cups			: int = 0
var _current_cups 		: int = 0
var _attempts 			: int = -1


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"): get_tree().change_scene_to_packed(MAIN)


func _ready() -> void:
	get_tree().paused = false
	SignalBus.cup_died.connect(_on_cup_died)
	SignalBus.animal_died.connect(_on_animal_died)
	_total_cups = get_tree().get_nodes_in_group(Cup.GROUP_NAME).size()
	level_number.text = "%04d" % ScoreManager.level_selected
	on_attempt_made()


func _on_cup_died() -> void:
	_current_cups += 1
	if _current_cups == _total_cups: 
		level_complete.show()
		music.play()
		ScoreManager.set_score_for_current_level(_attempts)
		get_tree().paused = true


func _on_animal_died() -> void: 
	on_attempt_made()


func on_attempt_made () -> void: 
	_attempts += 1
	attempts_number.text = "%04d" % _attempts
