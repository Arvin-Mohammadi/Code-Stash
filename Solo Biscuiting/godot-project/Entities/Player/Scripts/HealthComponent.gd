extends Node2D

@export var movement_component 		:  Node2D
@export var combat_component 		:  Node2D
@export var animation_component 	:  Node2D
@export var max_health 				:= 100
var current_health     				:  int
@export var biscuit_inventory : Node2D

func _ready() -> void:
	current_health = max_health
	GlobalSignalBus.player_damaged.connect(_on_player_damaged)
	
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("EAT"):
		_eat_biscuit()

func _eat_biscuit() -> void:
	if biscuit_inventory.consume_biscuit():
		_gain_health(30)
		GlobalSignalBus.emit_signal("health_updated", current_health)

func _take_damage(amount: int) -> void:
	current_health = max(current_health - amount, 0)

func _gain_health(amount: int) -> void:
	current_health = min(current_health + amount, 100)

func _on_player_damaged(amount: int) -> void: 
	movement_component.abort 	= true 
	combat_component.abort 		= true 
	animation_component.set_animation("take_damage")
	
	_take_damage(amount)
	GlobalSignalBus.emit_signal("health_updated", current_health)
	if current_health <= 0:	GlobalSignalBus.player_died.emit()


func _on_animation_tree_animation_finished(_animation_name: StringName) -> void:
	if _animation_name == "take_damage_right" or "take_damage_left":
		movement_component.abort 	= false
		combat_component.abort 		= false
