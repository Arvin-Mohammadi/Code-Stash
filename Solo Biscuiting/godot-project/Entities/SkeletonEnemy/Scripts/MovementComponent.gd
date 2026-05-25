extends Node2D

var skeleton_enemy   			:  CharacterBody2D
@export var speed    			:= 10.0
@onready var input_vector 		:= Vector2.ZERO

func _ready() -> void: skeleton_enemy = get_parent()

func _physics_process(_delta: float) -> void:
	
	# update skeleton_enemy movement 
	var movement    := _calculate_movement(input_vector, _delta)
	skeleton_enemy.position += movement
	
func _calculate_movement(_input_vector: Vector2, _delta: float) -> Vector2:
	
	var movement     := _input_vector.normalized() * speed * _delta
	var new_position := skeleton_enemy.position + movement
	
	return new_position - skeleton_enemy.position
	
func set_input_vector(_vector: Vector2) -> void: input_vector = _vector
