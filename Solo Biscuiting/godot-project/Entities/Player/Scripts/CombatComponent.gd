extends Node2D

@export var damage_amount        := 30
@export var animation_component  :  Node2D
@export var player               :  CharacterBody2D
@export var movement_component   :  Node2D
@export var biscuit_inventory : Node2D

@onready var abort               := false

var enemies_left  : Array[CharacterBody2D] = []
var enemies_right : Array[CharacterBody2D] = []

func _physics_process(_delta: float) -> void:
	_handle_attack_input()

func _handle_attack_input() -> void:
	if Input.is_action_just_pressed("MELEE-ATTACK"):
		_set_animation("MELEE-ATTACK")
	elif Input.is_action_just_pressed("RANGE-ATTACK"):
		_set_animation("RANGE-ATTACK")

func _set_animation(_input_key: String) -> void:
	if abort: return
	
	movement_component.abort = true
	
	if _input_key == "MELEE-ATTACK":
		animation_component.set_animation("melee_attack")
	elif _input_key == "RANGE-ATTACK":
		animation_component.set_animation("range_attack")

func _on_animation_tree_animation_finished(_animation_name: StringName) -> void:
	if _animation_name == "melee_attack_right":
		for enemy in enemies_right:
			GlobalSignalBus.emit_signal("enemy_damaged", enemy, damage_amount)
	elif _animation_name == "melee_attack_left":
		for enemy in enemies_left:
			GlobalSignalBus.emit_signal("enemy_damaged", enemy, damage_amount)
	
	if _animation_name in ["melee_attack_right", "melee_attack_left"]:
		movement_component.abort = false
		
	if _animation_name in ["range_attack_right", "range_attack_left"]:
		movement_component.abort = false
		_bullet_spawn()
		
func _bullet_spawn() -> void:
	if biscuit_inventory.consume_biscuit() == false:
		print("No biscuits left to throw!")
		return

	var bullet_scene := preload("res://Entities/Biscuit/Scenes/BiscuitAmmo.tscn")
	var bullet       := bullet_scene.instantiate()
	
	bullet.global_position = player.global_position
	
	var mouse_pos   := get_global_mouse_position()
	var direction   := (mouse_pos - player.global_position).normalized()
	bullet.set_direction(direction)
	
	get_tree().current_scene.add_child(bullet)

# --- Collision Callbacks ---
func _on_left_body_entered(body: Node2D) -> void:
	if body is SkeletonEnemy and body not in enemies_left:
		enemies_left.append(body)

func _on_left_body_exited(body: Node2D) -> void:
	if body in enemies_left:
		enemies_left.erase(body)

func _on_right_body_entered(body: Node2D) -> void:
	if body is SkeletonEnemy and body not in enemies_right:
		enemies_right.append(body)

func _on_right_body_exited(body: Node2D) -> void:
	if body in enemies_right:
		enemies_right.erase(body)
