extends CanvasLayer

@onready var click1 = $"ClickSound#1"
@onready var click2 = $"ClickSound#2"

signal unpause

func _on_pause_button_mouse_entered():
	click1.play()

func _on_pause_button_pressed():
	click2.play()
	unpause.emit()
