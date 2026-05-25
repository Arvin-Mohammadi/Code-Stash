extends Node2D

@onready var biscuit_count := 10

func _physics_process(_delta: float) -> void:
	_update_biscuit_count()

func _update_biscuit_count() -> void: 
	GlobalSignalBus.emit_signal("biscuit_count_updated", biscuit_count)

func consume_biscuit() -> bool:
	if biscuit_count > 0:
		biscuit_count -= 1
		_update_biscuit_count()
		return true
	return false
