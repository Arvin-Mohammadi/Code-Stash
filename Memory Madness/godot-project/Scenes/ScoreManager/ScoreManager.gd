class_name ScoreManager
extends Node

static var SelectionEnabled				: bool = true 

@onready var reveal_timer				: Timer = $RevealTimer

var _selected_tiles						: Array[MemoryTile]
var _pairs_made 						: int = 0
var _moves_made							: int = 0
var _target_pairs						: int = 0


func _ready() -> void:
	SignalHub.tile_selected.connect(_on_tile_selected)
	SignalHub.game_exit_pressed.connect(_on_game_exit_pressed)
 

func setup_new_game(target_pairs: int) -> void:
	_selected_tiles.clear()
	SelectionEnabled = true 
	_pairs_made = 0 
	_moves_made = 0
	SignalHub.move_made.emit(_moves_made)
	SignalHub.pair_made.emit(_pairs_made)
	_target_pairs = target_pairs


func check_for_pairs() -> void: 
	_moves_made += 1
	SignalHub.move_made.emit(_moves_made)
	
	if _selected_tiles[0].matches_other_tile(_selected_tiles[1]):
		_selected_tiles[0].kill_on_pair()
		_selected_tiles[1].kill_on_pair()
		_pairs_made += 1 
		SignalHub.pair_made.emit(_pairs_made)


func check_game_over() -> void: 
	if _pairs_made != _target_pairs:
		SelectionEnabled = true 
	else: 
		SignalHub.game_over.emit(_moves_made)


func process_pair() -> void: 
	if _selected_tiles.size() != 2: return 
	
	SelectionEnabled = false 
	reveal_timer.start()
	check_for_pairs()


func _on_tile_selected(tile: MemoryTile) -> void:
	if !SelectionEnabled: return 
	if tile in _selected_tiles: return 
	_selected_tiles.append(tile)
	process_pair()


func _on_reveal_timer_timeout() -> void:
	for tile in _selected_tiles: tile.reveal(false)
	SelectionEnabled = true 
	check_game_over()
	_selected_tiles.clear()


func _on_game_exit_pressed() -> void: 
	reveal_timer.stop()
	_selected_tiles.clear()
	SelectionEnabled = true 
