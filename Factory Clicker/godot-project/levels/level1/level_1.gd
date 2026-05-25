extends Node2D

# CONSTANTS
const DISTANCE = 19
const init_positions = [Vector2(126, 71), Vector2(31, 60), Vector2(126, 49), Vector2(31, 40)] 

# PRE-LOADS 
@onready var BOTS 				= [$Overlay/Bot1, $Overlay/Bot2, $Overlay/Bot3, $Overlay/Bot4]
@onready var click1 			= $"ClickSound#1"
@onready var click2 			= $"ClickSound#2"
@onready var music  			= $BackgroundMusic
@onready var pause_screen 		= $PauseMenu
@onready var score_text			= $Overlay/Score
@onready var belts				= [	$Foreground/ConveyorBelt, $Foreground/ConveyorBelt2, \
									$Foreground/ConveyorBelt3, $Foreground/ConveyorBelt4]
@onready var product_states 	= [	preload("res://levels/level1/product_state_1.tscn"),\
									preload("res://levels/level1/product_state_2.tscn"),\
									preload("res://levels/level1/product_state_3.tscn"),\
									preload("res://levels/level1/product_state_4.tscn")]
@onready var travel_distance	= [DISTANCE, DISTANCE, DISTANCE, DISTANCE]
@onready var is_moving			= [true, false, false, false]
@onready var instance_groups	= [[], [], [], []]
@onready var ready_to_use		= [0, 0, 0, 0, 0]
@onready var group_id = 0 
@onready var automate = [false, false, false, false]

func _ready():
	# INIT 
	_product_instantiate(1)

func _product_instantiate(product_number):

	# ADD THE SCORE 
	if product_number == 5: 
		ready_to_use[4] += 1 
		score_text.text = str(ready_to_use[4])
		return 

	# MAKING NEW PRODUCTS 
	var instance = product_states[product_number-1].instantiate()
	add_child(instance)
	instance.global_position = init_positions[product_number-1]
	instance_groups[product_number-1].append(instance)


func _process(_delta):
	
	# CHECK IF AUTOMATED 
	for i in range(4):
		if automate[i]: is_moving[i] = true 
		if automate[i] and (travel_distance[i] == DISTANCE): _product_instantiate(i+1)

	# MOVE THE LINE FORWARD 
	group_id = 0
	for instance_group in instance_groups:
		for instance in instance_groups[group_id]:
			if is_moving[group_id]: instance.global_position.x += pow(-1, group_id+1)
		if is_moving[group_id]: belts[group_id].global_position.x += pow(-1, group_id+1) 
		if is_moving[group_id]: travel_distance[group_id] -= 1
		group_id += 1

	# RESETING TRAVEL DISTANCE 
	group_id = 0
	for instance_group in instance_groups:
		if travel_distance[group_id] == 0: 
			belts[group_id].global_position.x = 80
			travel_distance[group_id] = DISTANCE
			is_moving[group_id] = false 

			if (pow(-1, group_id)*instance_group[0].global_position.x < (40*((group_id+1)%2) - 110*(group_id%2))):
				instance_group[0].queue_free()
				instance_group.remove_at(0)
				ready_to_use[group_id] += 0.5
				if group_id == 3: _product_instantiate(5)

		group_id += 1

	# CLICKING ON THE LINE
	for instance in instance_groups[0]:
		if instance.clicked and not is_moving[0]:
			_product_instantiate(1)
			is_moving[0] = true 
			instance.clicked = false  
	
	group_id = 1
	for instance_group in [instance_groups[1],instance_groups[2],instance_groups[3]]:
		for instance in instance_group:
			if instance.clicked and ready_to_use[group_id-1] >= 3 and not is_moving[group_id]: 
				is_moving[group_id] = true
				instance.clicked = false 
				ready_to_use[group_id-1] -= 1
				_product_instantiate(group_id+1)
			elif instance.clicked and ready_to_use[group_id-1] < 3 and not is_moving[group_id]:
				is_moving[group_id] = true 
				instance.clicked = false 
				ready_to_use[group_id-1] = 0 
		group_id += 1
		
	# PRODUCTS READY TO BE TRANSFORMED
	for i in range(0, 3):
		if (ready_to_use[i] == 1):
			_product_instantiate(i+2)
			is_moving[i+1] = true 
			ready_to_use[i] += 1
	
# HOVER CLICK SOUND 
func _on_music_mouse_entered():
	click1.play()
func _on_pause_mouse_entered():
	click1.play()
func _on_quit_mouse_entered():
	click1.play()
func _on_upgrade_1_mouse_entered():
	click1.play()
func _on_upgrade_2_mouse_entered():
	click1.play()
func _on_upgrade_3_mouse_entered():
	click1.play()
func _on_upgrade_4_mouse_entered():
	click1.play()

# UI FUNCTIONS
func _on_music_pressed():
	click2.play()
	if music.playing:
		music.stop()
	else: 
		music.play()
# -----------------------
func _on_quit_pressed():
	click2.play()
	get_tree().quit()
# -----------------------
func _on_pause_pressed():
	get_tree().paused 		= true
	pause_screen.visible 	= true 
	await pause_screen.unpause
	get_tree().paused 		= false 
	pause_screen.visible 	= false
# -----------------------
func _on_upgrade_1_pressed():
	click2.play()
	if int(score_text.text) >= 1: 
		automate[0] = true 
		BOTS[0].visible = true 
# -----------------------
func _on_upgrade_2_pressed():
	click2.play()
	if int(score_text.text) >= 2: 
		automate[1] = true 
		BOTS[1].visible = true 
# -----------------------
func _on_upgrade_3_pressed():
	click2.play()
	if int(score_text.text) >= 3: 
		automate[2] = true 
		BOTS[2].visible = true 
	# -----------------------
func _on_upgrade_4_pressed():
	click2.play()
	if int(score_text.text) >= 4: 
		automate[3] = true 
		BOTS[3].visible = true 
# -----------------------

	
	
