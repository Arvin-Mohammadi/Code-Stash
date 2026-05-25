extends Node

const MAIN 						= preload("uid://dkbkajpsuy6t8")
const GAME 						= preload("uid://ch0cbsx05k47l")
const SCORE_PATH 				: String = "user://tappyscore.res"
const SIMPLE_TRANSITION 		= preload("uid://dmb4beapxm0ey")
const FADE_TRANSITION 			= preload("uid://dtloo0d6ecg3c")

var fade_transition: FadeTransition
var next_scene 		: PackedScene
var high_score 		: int = 0:
	get: return high_score
	set(value): 
		if value > high_score: 
			high_score = value
			save_high_score()


func _ready() -> void:
	load_high_score()
	fade_transition = FADE_TRANSITION.instantiate()
	add_child(fade_transition)


func save_high_score() -> void:
	var _high_sore_resource: HighScoreResource = HighScoreResource.new()
	_high_sore_resource.high_score = high_score
	ResourceSaver.save(_high_sore_resource, SCORE_PATH)
	
	
func load_high_score() -> void:
	if ResourceLoader.exists(SCORE_PATH): 
		var _high_sore_resource: HighScoreResource = load(SCORE_PATH)
		if _high_sore_resource: high_score = _high_sore_resource.high_score
	
	
func load_main_scene() -> void: 
	get_tree().paused = false
	start_transition(MAIN)
	#next_scene = MAIN
	#get_tree().change_scene_to_packed(SIMPLE_TRANSITION)


func load_game_scene() -> void: 
	start_transition(GAME)
	#next_scene = GAME
	#get_tree().change_scene_to_packed(SIMPLE_TRANSITION)
	
	
func change_to_next() -> void:
	if next_scene: get_tree().change_scene_to_packed(next_scene)


func start_transition(to_scene: PackedScene) -> void: 
	next_scene = to_scene 
	fade_transition.play_anim()
