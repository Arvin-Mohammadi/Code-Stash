extends CanvasLayer
class_name FadeTransition


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func switch_scene() -> void:
	GameManager.change_to_next()  


func play_anim() -> void:
	animation_player.play("fade")
