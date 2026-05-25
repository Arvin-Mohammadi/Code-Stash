extends Node2D

var states						: Dictionary = {}
var current_state				: State
@export var initial_state		: State
@export var animation_component : Node2D

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(_on_child_transition)
			
	if initial_state:
		initial_state.enter()
		current_state = initial_state
		animation_component.set_animation(initial_state.name.to_lower())
			
func _process(_delta):
	if current_state: current_state.update(_delta)
	
func _physics_process(_delta: float) -> void:
	if current_state: current_state.physics_update(_delta)

func _on_child_transition(state, new_state_name):
	
	# change the current state to new state 
	if state != current_state: return 
	var new_state = states.get(new_state_name.to_lower())
	if !new_state: return
	if current_state: current_state.exit()
	new_state.enter()
	current_state = new_state
	
	animation_component.set_animation(new_state_name.to_lower())
