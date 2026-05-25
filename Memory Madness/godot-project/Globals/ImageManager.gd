extends Node

const TILE_IMAGES			: TileImagesHolder = preload("uid://dyw2yy8ir5px")
const FRAME_IMAGES			: Array[Texture2D] = [
	preload("uid://kuibfre6udh6"),
	preload("uid://bgyxkpfme1r5j"),
	preload("uid://bss041hcr5ivq"),
	preload("uid://2h1y06abek8f")
]


func get_random_frame_image() -> Texture2D: 
	return FRAME_IMAGES.pick_random()


func get_random_item_image() -> Texture2D:
	return TILE_IMAGES.tile_images.pick_random()


func shuffle_images() -> void: 
	TILE_IMAGES.tile_images.shuffle()


func get_image_at_index(index: int) -> Texture2D: 
	if index > TILE_IMAGES.tile_images.size() or index < 0:
		printerr("index out of bounds")
	return TILE_IMAGES.tile_images[index]
