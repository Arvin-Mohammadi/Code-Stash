class_name MemoryTile
extends TextureButton

@onready var frame_image		: TextureRect = $FrameImage
@onready var item_image			: TextureRect = $ItemImage


func _ready() -> void:
	reveal(false)


func setup(image: Texture2D, frame: Texture2D) -> void: 
	frame_image.texture = frame 
	item_image.texture	= image 


func matches_other_tile(other: MemoryTile) -> bool : 
	return other != self and other.item_image.texture == item_image.texture


func kill_on_pair() -> void: 
	z_index = 10
	disabled = true 
	var _tween: Tween = create_tween()
	_tween.set_parallel(true)
	_tween.tween_property(self, "rotation_degrees", 720, 0.5)
	_tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.5)
	_tween.set_parallel(false)
	_tween.tween_interval(0.5)
	_tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)


func reveal(revealed: bool) -> void: 
	frame_image.visible = revealed
	item_image.visible = revealed


func _on_pressed() -> void: 
	if !ScoreManager.SelectionEnabled: return 
	reveal(true)
	SignalHub.tile_selected.emit(self)
