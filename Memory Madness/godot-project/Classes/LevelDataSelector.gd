class_name LevelDataSelector

func get_images_for_level(level_setting: LevelSetting) -> Array[Texture2D]: 
	ImageManager.shuffle_images()
	var selected_images: Array[Texture2D] = []
	for i in range(level_setting.target_pairs):
		selected_images.append(ImageManager.get_image_at_index(i))
		selected_images.append(ImageManager.get_image_at_index(i))
	selected_images.shuffle()
	return selected_images
		
