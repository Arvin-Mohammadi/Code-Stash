class_name LevelScoresResource
extends Resource


const DEFAULT_SCORE			: int = 9999

@export var level_scores	: Dictionary[int, int]


func get_level_best(level: int) -> int: 
	return level_scores.get(level, DEFAULT_SCORE)


func try_update_best_score(level: int, score: int) -> void: 
	if get_level_best(level) > score: level_scores[level] = score
