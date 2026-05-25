extends State
class_name SkeletonEnemyAttackState

@export var skeleton_enemy		:  CharacterBody2D
@export var movement_component	:  Node2D
@export var damage_per_hit		:= 12

var player 						:  CharacterBody2D
var attack_timer 				:  float
var player_in_left				:= false
var player_in_right				:= false

func enter():
	player = get_tree().get_first_node_in_group("Player")
	
	# stop movement while attacking
	movement_component.set_input_vector(Vector2.ZERO)
	movement_component.speed = 0.0
	
func _on_animation_tree_animation_finished(_animation_name: StringName) -> void:
	
	if (_animation_name == "attack_left") and (player_in_left):
		GlobalSignalBus.emit_signal("player_damaged", damage_per_hit)
	elif (_animation_name == "attack_right") and (player_in_right): 
		GlobalSignalBus.emit_signal("player_damaged", damage_per_hit)
	
	if _animation_name == "attack_left" or "attack_right": Transitioned.emit(self, "Follow")
	
func _on_left_body_entered(body: Node2D) -> void:
	if body.name == "Player": player_in_left = true

func _on_left_body_exited(body: Node2D) -> void:
	if body.name == "Player": player_in_left = false
	
func _on_right_body_entered(body: Node2D) -> void:
	if body.name == "Player": player_in_right = true

func _on_right_body_exited(body: Node2D) -> void:
	if body.name == "Player": player_in_right = false
