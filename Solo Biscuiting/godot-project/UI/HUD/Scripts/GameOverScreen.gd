extends CanvasLayer

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed(): get_tree().quit()
