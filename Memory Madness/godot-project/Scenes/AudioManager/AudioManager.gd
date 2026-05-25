extends Node

@onready var music				: AudioStreamPlayer = $Music
@onready var sfx				: AudioStreamPlayer = $SFX

@export var main_menu_music		: AudioStream
@export var game_music			: AudioStream
@export var click_sound			: AudioStream
@export var tile_sound			: AudioStream
@export var game_over_sound		: AudioStream


func _ready() -> void:
	SignalHub.level_selected.connect(_on_level_selected)
	SignalHub.game_exit_pressed.connect(_on_game_exit_pressed)
	SignalHub.tile_selected.connect(_on_tile_selected)
	SignalHub.pair_made.connect(_on_pair_made)
	SignalHub.game_over.connect(_on_game_over)
	play_music(main_menu_music)
	
	
func play_music(stream: AudioStream) -> void: 
	music.stream = stream 
	music.play()


func play_sfx(stream: AudioStream) -> void: 
	sfx.stream = stream 
	sfx.play()


func _on_level_selected(_level_setting: LevelSetting) -> void: 
	play_music(game_music) 
	play_sfx(click_sound)


func _on_game_exit_pressed() -> void: 
	play_music(main_menu_music)
	

func _on_tile_selected(_tile: MemoryTile) -> void: 
	play_sfx(tile_sound)


func _on_pair_made(_number_of_pairs: int) -> void: 
	play_sfx(tile_sound)


func _on_game_over(_number_of_moves: int) -> void: 
	play_sfx(game_over_sound)
