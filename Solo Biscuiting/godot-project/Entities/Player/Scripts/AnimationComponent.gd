extends Node2D

@export var animation_tree 		: AnimationTree
@export var movement_component 	: Node2D
@export var animation_player	: AnimationPlayer
@export var player				: CharacterBody2D

var last_facing_direction		:= -1
var animation_name				: String = "idle"
var previous_animation_name		: String = ""
var mouse_direction				:= 1 # +1 = right, -1 = left
var player_scale_on_attack		:= 1.0

func _ready() -> void: 
	animation_player["active"] = true
	animation_tree["active"]   = true

func _physics_process(_delta: float) -> void:
	
	_set_blend_positions()
	
	if previous_animation_name == animation_name: return
	
	_match_animations()
	
	previous_animation_name = animation_name
	
func _set_blend_positions() -> void:
	if movement_component.input_vector.x != 0:
		last_facing_direction = round(movement_component.input_vector.x)
	
	animation_tree.set("parameters/Run/blend_position", last_facing_direction)
	animation_tree.set("parameters/Idle/blend_position", last_facing_direction) 
	animation_tree.set("parameters/TakeDamage/blend_position", last_facing_direction) 
	animation_tree.set("parameters/MeleeAttack/blend_position", last_facing_direction)

	mouse_direction = _determine_mouse_direction()
	animation_tree.set("parameters/RangeAttack/blend_position", mouse_direction)

func _match_animations() -> void:
	match animation_name:
		"idle":
			animation_tree.set("parameters/conditions/idle", true)
			animation_tree.set("parameters/conditions/run", false)
			animation_tree.set("parameters/conditions/is_attacking", false)
			animation_tree.set("parameters/conditions/is_throwing", false)
			animation_tree.set("parameters/conditions/player_damaged", false)
		"run":
			animation_tree.set("parameters/conditions/idle", false)
			animation_tree.set("parameters/conditions/run", true)
			animation_tree.set("parameters/conditions/is_attacking", false)
			animation_tree.set("parameters/conditions/is_throwing", false)
			animation_tree.set("parameters/conditions/player_damaged", false)
		"melee_attack": 
			animation_tree.set("parameters/conditions/idle", false)
			animation_tree.set("parameters/conditions/run", false)
			animation_tree.set("parameters/conditions/is_attacking", true)
			animation_tree.set("parameters/conditions/is_throwing", false)
			animation_tree.set("parameters/conditions/player_damaged", false)
		"range_attack":
			animation_tree.set("parameters/conditions/idle", false)
			animation_tree.set("parameters/conditions/run", false)
			animation_tree.set("parameters/conditions/is_attacking", false)
			animation_tree.set("parameters/conditions/is_throwing", true)
			animation_tree.set("parameters/conditions/player_damaged", false)
		"take_damage":
			animation_tree.set("parameters/conditions/idle", false)
			animation_tree.set("parameters/conditions/run", false)
			animation_tree.set("parameters/conditions/is_attacking", false)
			animation_tree.set("parameters/conditions/is_throwing", false)
			animation_tree.set("parameters/conditions/player_damaged", true)
			
func set_animation(_animation_name: String) -> void: animation_name = _animation_name

func _determine_mouse_direction() -> int:
	var mouse_global_position 	:= get_global_mouse_position()
	var relative       			= mouse_global_position.x - player.global_position.x
	
	if relative >= 0			: return 1
	else						: return -1
