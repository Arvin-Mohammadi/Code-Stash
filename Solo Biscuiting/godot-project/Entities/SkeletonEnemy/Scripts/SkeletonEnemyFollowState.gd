extends State
class_name SkeletonEnemyFollowState

@export var skeleton_enemy		: CharacterBody2D
@export var movement_component	: Node2D
@export var follow_distance		: float = 100.0
@export var attack_trigger		: float = 10.0

var player 						: CharacterBody2D

func enter():
	player = get_tree().get_first_node_in_group("Player")

func update(_delta):
	if not player: return
	
	var distance = player.global_position.distance_to(skeleton_enemy.global_position) 
	
	if distance > follow_distance:
		Transitioned.emit(self, "Wander")
	elif distance < attack_trigger:
		Transitioned.emit(self, "Attack")

func physics_update(_delta):
	if not player: return
	var direction = (player.global_position - skeleton_enemy.global_position).normalized()
	movement_component.speed = 10.0
	movement_component.set_input_vector(direction)
