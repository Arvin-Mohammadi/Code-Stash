extends Node


const SCORES_PATH		= "user://animals_scores.res"

var level_selected		: int = 1:
	get: return level_selected
	set (value): level_selected = value
	
var _level_scores		: LevelScoresResource = LevelScoresResource.new()


func _ready() -> void:
	load_scores_from_file()


func get_level_best(level: int) -> int: 
	return _level_scores.get_level_best(level)


func set_score_for_current_level(score: int) -> void:
	_level_scores.try_update_best_score(level_selected, score)
	save_scores_from_file()


func load_scores_from_file() -> void: 
	if ResourceLoader.exists(SCORES_PATH): 
		_level_scores = load(SCORES_PATH)


func save_scores_from_file() -> void: 
	ResourceSaver.save(_level_scores, SCORES_PATH)
