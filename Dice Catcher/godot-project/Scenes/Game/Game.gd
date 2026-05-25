extends Node2D

const GAME_OVER 			= preload("uid://bulvbcosa5iuq")
const DICE 					= preload("uid://crt54leh0teoi")
const MARGIN				: float = 120.0
const STOPPABLE_GROUP		: String = "stoppable"


@onready var dice_spawn_timer		: Timer = $DiceSpawnTimer
@onready var score_label			: Label = $ScoreLabel
@onready var music				: AudioStreamPlayer = $Music


var _points: int = 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

func _ready() -> void:
	update_score_label()
	dice_spawn_timer.timeout.connect(_on_dice_spawn_timer_timeout)

func spawn_dice() -> void: 
	var new_dice			: Dice = DICE.instantiate()
	var viewport_rect		: Rect2 = get_viewport_rect()
	var rand_x				: float = randf_range(
		viewport_rect.position.x + MARGIN, 
		viewport_rect.end.x - MARGIN
	)
	new_dice.position = Vector2(rand_x, -MARGIN)
	new_dice.game_over.connect(_on_game_over)
	add_child(new_dice)

func pause_all() -> void: 
	dice_spawn_timer.stop()
	var to_stop: Array[Node] = get_tree().get_nodes_in_group(STOPPABLE_GROUP)
	for item in to_stop: 
		item.set_physics_process(false)

func _on_game_over() -> void: 
	pause_all() 
	music.stop()
	music.stream = GAME_OVER
	music.play()

func _on_dice_spawn_timer_timeout() -> void: 
	spawn_dice()

func update_score_label() -> void: 
	score_label.text = "%04d" % _points
	

func _on_fox_point_scored() -> void:
	_points += 1
	update_score_label()
