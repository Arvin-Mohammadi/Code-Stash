extends Node2D

@export var animation_component		:  Node2D
@export var movement_compoennt		:  Node2D
@export var skeleton_enemy			:  CharacterBody2D
@export var max_health 				:= 100
var current_health     				:  int
@onready var health_bar				:= $HealthBar

func _ready() -> void:
	current_health = max_health
	GlobalSignalBus.enemy_damaged.connect(_on_enemy_damaged)

func _take_damage(amount: int) -> void:
	current_health = max(current_health - amount, 0)
	health_bar.value = current_health
	if current_health <= 0: 
		movement_compoennt.set_input_vector(Vector2.ZERO)
		animation_component.set_animation("death")

func _on_enemy_damaged(enemy: CharacterBody2D, damage_amount: int) -> void:
	if enemy == skeleton_enemy: _take_damage(damage_amount) 


func _on_animation_tree_animation_finished(_animation_name: StringName) -> void:
		if _animation_name in ["death_left", "death_right"]:
			skeleton_enemy.queue_free()
