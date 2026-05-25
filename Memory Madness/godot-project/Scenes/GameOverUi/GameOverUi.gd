extends PanelContainer

@onready var moves		: Label = $VBoxContainer/Moves


func _ready() -> void:
	SignalHub.game_over.connect(_on_game_over)
	SignalHub.game_exit_pressed.connect(_on_game_exit_pressed)
		
func _on_game_over(_moves_made: int) -> void: 
	moves.text = "You Took %d Moves" % _moves_made
	show()

func _on_game_exit_pressed() -> void: 
	hide()
