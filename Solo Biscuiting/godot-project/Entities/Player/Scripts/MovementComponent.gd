extends Node2D

@export var speed: float = 100.0
@export var animation_component: Node2D

var player: CharacterBody2D
var input_vector: Vector2 = Vector2.ZERO
var abort: bool = false

func _ready() -> void:
	player = get_parent() as CharacterBody2D

func _physics_process(_delta: float) -> void:
	# read input
	input_vector = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN").normalized()
	
	# apply movement only if not aborted
	if !abort:
		player.velocity = input_vector * speed
		player.move_and_slide()
	else:
		player.velocity = Vector2.ZERO
	
	_set_animation()

func _set_animation() -> void:
	if abort:
		return

	if input_vector != Vector2.ZERO:
		animation_component.set_animation("run")
	else:
		animation_component.set_animation("idle")
