extends Node2D


const PIPES 		= preload("uid://okg74sl06u14")


@onready var upper_spawn		: Marker2D = $UpperSpawn
@onready var lower_spawn		: Marker2D = $LowerSpawn
@onready var pipes_holder		: Node2D = $PipesHolder
@onready var spawn_timer		: Timer = $SpawnTimer


func _on_spawn_timer_timeout() -> void: spawn_pipes()


func spawn_pipes() -> void:
	var new_pipes : Pipes = PIPES.instantiate()
	new_pipes.global_position.x = upper_spawn.global_position.x
	new_pipes.global_position.y = randf_range(
		upper_spawn.global_position.y, 
		lower_spawn.global_position.y
		)
	pipes_holder.add_child(new_pipes)
