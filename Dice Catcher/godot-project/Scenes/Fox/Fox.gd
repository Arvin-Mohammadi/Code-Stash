extends Area2D
class_name Fox

signal point_scored

const SPEED			: float = 350.0 

@onready var sprite: Sprite2D = $Sprite
@onready var sounds: AudioStreamPlayer2D = $Sounds

func _physics_process(delta: float) -> void:
	var move_dir : float = Input.get_axis("ui_left", "ui_right")
	position.x += move_dir * delta * SPEED 
	if !is_zero_approx(move_dir): sprite.flip_h = move_dir > 0.0
	
func _on_area_entered(area: Area2D) -> void:
	if area is Dice: 
		point_scored.emit()
		sounds.play()
		area.queue_free()
