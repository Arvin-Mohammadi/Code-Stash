extends State
class_name SkeletonEnemyWanderState

@export var skeleton_enemy				: CharacterBody2D
@export var follow_trigger_radius 		:= 30.0
@export var movement_component			: Node2D
@export var wander_probability			:= 0.8

var player 						: CharacterBody2D
var wander_direction			: Vector2
var wander_time 				: float

func enter(): 
	player = get_tree().get_first_node_in_group("Player")
	_randomize_wander()

func update(_delta): 
	var distance = player.global_position.distance_to(skeleton_enemy.global_position)
	if distance < follow_trigger_radius: Transitioned.emit(self, "Follow")
	if wander_time > 0:	wander_time -= _delta
	else: _randomize_wander()

func physics_update(_delta): 
	movement_component.speed = 10.0
	movement_component.set_input_vector(wander_direction)

func _randomize_wander():
	wander_direction 	= Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time 		= randf_range(1.5, 3)

	if randf() > wander_probability: Transitioned.emit(self, "Idle")
