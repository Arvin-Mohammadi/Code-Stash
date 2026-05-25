extends Node2D

@export var animation_tree 		: AnimationTree
@export var movement_component 	: Node2D
@export var animation_player	: AnimationPlayer

var last_facing_direction		:= -1
var animation_name				: String = "idle"
var previous_animation_name		: String = ""

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
	animation_tree.set("parameters/Attack/blend_position", last_facing_direction)
	animation_tree.set("parameters/Death/blend_position", last_facing_direction)

func _match_animations() -> void:
	match animation_name:
		"idle":
			animation_tree.set("parameters/conditions/is_attacking", false)
			animation_tree.set("parameters/conditions/idle", true)
			animation_tree.set("parameters/conditions/run", false)
			animation_tree.set("parameters/conditions/death", false)
		"wander", "follow":
			animation_tree.set("parameters/conditions/is_attacking", false)
			animation_tree.set("parameters/conditions/idle", false)
			animation_tree.set("parameters/conditions/run", true)
			animation_tree.set("parameters/conditions/death", false)
		"attack":
			animation_tree.set("parameters/conditions/is_attacking", true)
			animation_tree.set("parameters/conditions/idle", false)
			animation_tree.set("parameters/conditions/run", false)
			animation_tree.set("parameters/conditions/death", false)
		"death":
			animation_tree.set("parameters/conditions/is_attacking", false)
			animation_tree.set("parameters/conditions/idle", false)
			animation_tree.set("parameters/conditions/run", false)
			animation_tree.set("parameters/conditions/death", true)

func set_animation(_animation_name: String) -> void: animation_name = _animation_name
