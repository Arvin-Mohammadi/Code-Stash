extends State
class_name SkeletonEnemyIdleState

@export var skeleton_enemy				: CharacterBody2D
@export var movement_component			: Node2D
@export var idle_probability			:= 0.7
@export var follow_trigger_radius 		:= 30.0

var player 						: CharacterBody2D
var idle_time 					: float

func enter(): 
	player = get_tree().get_first_node_in_group("Player")
	_randomize_idle()

func update(_delta): 
	
	# check for player close by
	var distance = player.global_position.distance_to(skeleton_enemy.global_position)
	if distance < follow_trigger_radius: Transitioned.emit(self, "Follow")
	
	# update timer
	if idle_time > 0: idle_time -= _delta
	else: _randomize_idle()

func physics_update(_delta): 
	movement_component.speed = 0.0
	movement_component.set_input_vector(Vector2.ZERO)

func _randomize_idle():
	idle_time = randf_range(1.5, 3)
	if randf() > idle_probability:	Transitioned.emit(self, "Wander")
