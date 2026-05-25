extends Node2D

@onready var clicked 		= false 
@onready var mouse_inside 	= false 

func _on_area_2d_mouse_entered():
	mouse_inside = true 

func _on_area_2d_mouse_exited():
	mouse_inside = false 
	
func _process(_delta):
	if Input.is_action_just_pressed("MouseLeft") and mouse_inside:
		clicked = true 
	if not mouse_inside: 
		clicked = false 
