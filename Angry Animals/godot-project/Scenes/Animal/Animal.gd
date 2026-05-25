class_name Animal
extends RigidBody2D


const DRAG_LIN_MAX			: Vector2 = Vector2(0, 60)
const DRAG_LIN_MIN			: Vector2 = Vector2(-60, 0)
const IMPULSE_MULT			: float = 25.0
const IMPULSE_MAX			: float = 2000.0

@onready var arrow			: Sprite2D = $Arrow
@onready var debug			: Label = $Debug
@onready var kick_sound		: AudioStreamPlayer2D = $KickSound
@onready var launch_sound	: AudioStreamPlayer2D = $LaunchSound
@onready var stretch_sound	: AudioStreamPlayer2D = $StretchSound
@onready var _arrow_scale_x : float = arrow.scale.x

var _start 					: Vector2 = Vector2.ZERO
var _drag_start 			: Vector2 = Vector2.ZERO
var _dragged_vector			: Vector2 = Vector2.ZERO
var _is_dragging 			: bool = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("drag") and _is_dragging: call_deferred("start_release")


func _ready() -> void:
	_start = global_position


func _process(_delta: float) -> void:
	var debug_string: String = "FR: %s • CC: %d • SL: %s\n" % [
		freeze,
		get_contact_count(),
		sleeping
	] 
	
	debug_string += "_is_dragging: %s • _drag_start: %.0f, %.0f\n" % [
		_is_dragging, 
		_drag_start.x, 
		_drag_start.y
	]
	
	debug_string += "_dragged_vector: %.0f, %.0f • _impulse: %.0f" % [
		_dragged_vector.x, 
		_dragged_vector.y,
		_calculate_impulse().length() 
	]
	
	debug.text = debug_string


func _physics_process(_delta: float) -> void:
	if _is_dragging: handle_dragging()


func _calculate_impulse() -> Vector2: 
	return _dragged_vector * IMPULSE_MULT * -1


func handle_dragging() -> void:
	var _new_dragged_vector			: Vector2 = get_global_mouse_position() - _drag_start
	_new_dragged_vector = _new_dragged_vector.clamp(DRAG_LIN_MIN, DRAG_LIN_MAX)
	
	var difference					: Vector2 = _new_dragged_vector - _dragged_vector
	if difference.length() > 0 and !stretch_sound.playing: stretch_sound.play() 
	
	scale_arrow()
	_dragged_vector = _new_dragged_vector
	position = _start + _dragged_vector


func start_dragging() -> void: 
	arrow.show()
	_is_dragging = true
	_drag_start = get_global_mouse_position()


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("drag"):
		input_event.disconnect(_on_input_event)
		start_dragging()
		
	
func start_release() -> void: 
	arrow.hide()
	_is_dragging = false
	freeze = false
	apply_central_impulse(_calculate_impulse())
	launch_sound.play()


func scale_arrow() -> void: 
	var impulse_length 		: float = _calculate_impulse().length()
	var normalized_length	: float = clamp(impulse_length / IMPULSE_MAX, 0.0, 1.0)
	arrow.scale.x 			= lerpf(_arrow_scale_x, _arrow_scale_x*2, normalized_length)
	arrow.rotation 			= (_start - global_position).angle()


func die() -> void: 
	SignalBus.animal_died.emit()
	queue_free()


func _on_body_entered(body: Node) -> void:
	if body is Cup and !kick_sound.playing: kick_sound.play()


func _on_sleeping_state_changed() -> void:
	if sleeping: 
		for body in get_colliding_bodies():
			if body is Cup: body.die()
		die()
