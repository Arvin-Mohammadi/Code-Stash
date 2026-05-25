extends CanvasLayer

signal on_transition_finsihed

@onready var color = $Color
@onready var animation_player = $AnimationPlayer

func _ready():
	color.visible = false
	animation_player.animation_finished.connect(_on_animation_finished) 
	
func transition():
	color.visible = true 
	animation_player.play("fade_to_black")
	
func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		on_transition_finsihed.emit()
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		color.visible = false 
