extends TextureProgressBar

func _ready() -> void: 
	GlobalSignalBus.health_updated.connect(_on_health_updated)
		
func _on_health_updated(current_health) -> void:
	value = current_health
