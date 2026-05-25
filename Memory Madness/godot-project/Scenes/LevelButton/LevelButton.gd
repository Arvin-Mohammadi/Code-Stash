extends TextureButton

@export var level_setting			: LevelSetting

@onready var label					: Label = $Label


func _ready() -> void:
	label.text = level_setting._to_string()


func _on_pressed() -> void:
	SignalHub.level_selected.emit(level_setting)
