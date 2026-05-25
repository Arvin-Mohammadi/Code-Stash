extends Node2D


const ANIMAL 						= preload("uid://blka8nob1t0pq")

@onready var spawn_point			: Marker2D = $SpawnPoint


func _ready() -> void:
	SignalBus.animal_died.connect(_on_animal_died)
	spawn_animal()
	

func spawn_animal() -> void: 
	var _new_animal: Animal = ANIMAL.instantiate()
	_new_animal.global_position = spawn_point.global_position
	add_child(_new_animal)


func _on_animal_died() -> void: 
	call_deferred("spawn_animal")
