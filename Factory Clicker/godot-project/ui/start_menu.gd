extends CanvasLayer

@onready var click1 = $"ClickSound#1"
@onready var click2 = $"ClickSound#2"

@export var next_level: PackedScene

func _on_start_button_pressed():
	click2.play()
	FadeTransition.transition()
	await FadeTransition.on_transition_finsihed
	get_tree().change_scene_to_packed(next_level)
#
func _on_start_button_mouse_entered():
	click1.play()
