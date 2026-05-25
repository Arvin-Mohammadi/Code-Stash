extends HBoxContainer

@onready var label : Label = $Label

func _ready() -> void: 
	GlobalSignalBus.biscuit_count_updated.connect(_on_biscuit_count_updated)
		
func _on_biscuit_count_updated(biscuit_count: int) -> void:
	label.text = "x%03d" % biscuit_count
