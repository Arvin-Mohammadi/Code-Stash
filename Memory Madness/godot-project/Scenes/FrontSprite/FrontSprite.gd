extends TextureRect


func _ready() -> void:
	set_random_item_image()
	animate_textures()
	

func set_random_item_image() -> void: 
	texture = ImageManager.get_random_item_image()


func get_random_spin_time() -> float: 
	return randf_range(1.0, 2.0)
	

func get_random_rotation() -> float: 
	return deg_to_rad(randf_range(-360.0, +360.0))


func animate_textures() -> void: 
	var _tween: Tween = create_tween()
	_tween.tween_property(self, "rotation", get_random_rotation(), get_random_spin_time())
	_tween.tween_property(self, "scale", Vector2(0.05, 0.05), get_random_spin_time())
	_tween.tween_callback(set_random_item_image)
	_tween.tween_property(self, "scale", Vector2(1, 1), get_random_spin_time())
	_tween.tween_interval(0.1)
	_tween.tween_callback(animate_textures)
	
	
