extends Area2D
class_name Dice 

signal game_over

const SPEED				: float 		= 100.0
const ROTATION_SPEED 	: float 		= 3.5

@onready var sprite		: Sprite2D 	= $Sprite  # No underscore - public property
@onready var rotation_dir	: float		= 1.0      # No underscore - public property

func _ready() -> void:
	if randf() <= 0.5: 
		rotation_dir *= -1.0

func _physics_process(delta: float) -> void:
	global_position.y += SPEED * delta 
	sprite.global_rotation += ROTATION_SPEED * delta * rotation_dir
	_check_game_over()  # Call the renamed private method

func _check_game_over() -> void:  # Underscore - this is for internal use only
	if get_viewport_rect().end.y < global_position.y: 
		game_over.emit()
		queue_free()
