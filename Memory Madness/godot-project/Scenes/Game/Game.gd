extends Control

const MEMORY_TILE 					= preload("uid://cevqdar0spfew")

@onready var grid_container			: GridContainer = $HContainer/GridContainer
@onready var score_manager			: ScoreManager = $ScoreManager
@onready var pairs_score			: Label = $HContainer/VContainer/Pairs/Score
@onready var moves_score			: Label = $HContainer/VContainer/Moves/Score

var target_pairs					: int = -1


func _ready() -> void:
	SignalHub.level_selected.connect(_on_level_selected)
	SignalHub.pair_made.connect(_on_pair_made)
	SignalHub.move_made.connect(_on_move_made)
	

func _on_move_made(number_of_moves: int) -> void: 
	moves_score.text = str(number_of_moves)


func _on_pair_made(number_of_pairs: int) -> void: 
	pairs_score.text = str(number_of_pairs) + " / " + str(target_pairs)


func _on_level_selected(level_setting: LevelSetting) -> void: 
	
	var level_data_selector		: LevelDataSelector = LevelDataSelector.new()
	var selected_images			: Array[Texture2D] = level_data_selector.get_images_for_level(level_setting)
	var frame_image 			: Texture2D = ImageManager.get_random_frame_image()
	
	grid_container.columns = level_setting.cols
	for image in selected_images:
		var new_tile: MemoryTile = MEMORY_TILE.instantiate()
		grid_container.add_child(new_tile)
		new_tile.setup(image, frame_image)
	
	target_pairs = level_setting.target_pairs
	score_manager.setup_new_game(target_pairs)
	_on_pair_made(0)


func _on_exit_button_pressed() -> void:
	for t in grid_container.get_children():
		t.queue_free()
	
	SignalHub.game_exit_pressed.emit()
