extends CanvasLayer

func _on_exit_pressed() -> void: get_tree().quit()

func _on_resume_pressed() -> void:
	visible    				= false
	get_tree().paused       = false
	
