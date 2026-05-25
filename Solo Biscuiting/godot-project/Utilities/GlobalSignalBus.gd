extends Node

@warning_ignore("unused_signal")
signal health_updated(current_health: int)

@warning_ignore("unused_signal")
signal player_damaged(damage_amount: int)

@warning_ignore("unused_signal")
signal player_died

@warning_ignore("unused_signal")
signal biscuit_count_updated(biscuit_count: int)

@warning_ignore("unused_signal")
signal enemy_damaged(enemy: CharacterBody2D, damage_amount: int)
