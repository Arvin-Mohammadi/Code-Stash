extends Node

@warning_ignore("unused_signal")
signal level_selected(level_setting: LevelSetting)

@warning_ignore("unused_signal")
signal game_exit_pressed

@warning_ignore("unused_signal")
signal tile_selected(tile: MemoryTile)

@warning_ignore("unused_signal")
signal pair_made(number_of_pairs: int)

@warning_ignore("unused_signal")
signal move_made(number_of_moves: int)

@warning_ignore("unused_signal")
signal game_over(number_of_moves: int)
