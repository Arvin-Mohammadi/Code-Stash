extends Node2D
class_name Pipes


@onready var laser				: Area2D = $Laser
@onready var score_sound		: AudioStreamPlayer = $ScoreSound


const SPEED 			: float = 120.0


func _ready() -> void:
	SignalBus.on_plane_died.connect(_on_plane_died) 


func _physics_process(delta: float) -> void:
	position.x -= SPEED * delta


func _on_screen_notifier_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Tappy: body.die()


func _on_laser_body_exited(body: Node2D) -> void:
	if body is Tappy: 
		_disconnect_laser()
		SignalBus.point_scored.emit()
		score_sound.play()


func _disconnect_laser() -> void:
	if laser.body_exited.is_connected(_on_laser_body_exited):
		laser.body_exited.disconnect(_on_laser_body_exited)


func _on_plane_died() -> void:
	_disconnect_laser()
