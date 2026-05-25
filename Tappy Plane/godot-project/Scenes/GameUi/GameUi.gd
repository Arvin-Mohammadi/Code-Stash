extends Control
class_name GameUI


@onready var press_space_timer			: Timer = $PressSpaceTimer
@onready var game_over					: Label = $Container/GameOver
@onready var press_space				: Label = $Container/PressSpace
@onready var sound						: AudioStreamPlayer = $Sound
@onready var _points					: int = 0
@onready var score						: Label = $Container/Score



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("power") and press_space.visible: 
		GameManager.load_main_scene()	
	if event.is_action_pressed("ui_cancel") and !get_tree().paused: 
		GameManager.load_main_scene()


func _ready() -> void:
	SignalBus.on_plane_died.connect(on_plane_died)
	SignalBus.point_scored.connect(on_point_scored)


func on_plane_died() -> void:
	GameManager.high_score = _points
	sound.play()
	game_over.show()
	press_space_timer.start()


func on_point_scored() -> void: 
	_points += 1
	score.text = "%04d" % _points
	


func _on_press_space_timer_timeout() -> void:
	game_over.hide()
	press_space.show()
	
