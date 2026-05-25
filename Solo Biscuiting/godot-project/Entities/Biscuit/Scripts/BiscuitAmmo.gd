extends Area2D

@export var raycast			: RayCast2D 

@export var speed				= 400
@export var damage				= 50


var is_fired					:= false
var velocity					:= Vector2.ZERO
var enemy 						:  CharacterBody2D

func _ready():
	print("i'm a fuck head")

func _physics_process(delta: float) -> void:
	
	# update bullet position
	position += velocity * delta
	
	# collision checks
	_raycast_collision_check()
	

func set_direction(dir: Vector2) -> void:
	
	# set initial direction
	print(velocity)
	print(dir)
	print(speed)
	velocity = dir * speed
	rotation = atan2(velocity.x, -velocity.y)
	raycast.target_position = dir * 5


func _on_body_exited(_body: Node2D) -> void:
	
	is_fired = true


func _on_body_entered(_body: Node2D) -> void:
	if _body is CharacterBody2D: enemy = _body

	
func _raycast_collision_check():
	
	if !is_fired: return
	
	# If bullet is colliding, send signal
	if raycast.is_colliding():
		print("I've send the signal")
		GlobalSignalBus.emit_signal("enemy_damaged", enemy, damage)
		queue_free()
