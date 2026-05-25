extends CharacterBody2D
class_name Tappy


const JUMP_POWER	: float = 350.0


@onready var sprite: AnimatedSprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _gravity 		: float = ProjectSettings.get("physics/2d/default_gravity")
var _jump			: bool = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("power"): 
		_jump = true
		animation_player.play("thrust")
	
		
func _physics_process(delta: float) -> void:
	velocity.y += _gravity * delta
	if _jump: velocity.y = -JUMP_POWER; _jump = false
	
	move_and_slide()

	if is_on_floor(): die()
	
	
func die() -> void:
	SignalBus.on_plane_died.emit()
	get_tree().paused = true 


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "thrust": animation_player.play("fall")
