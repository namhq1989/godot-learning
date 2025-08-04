extends Control

@onready var score_label: Label = $MarginContainer/ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	score_label.text = "%04d" % ScoreManager.high_score

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and event.is_echo() == false:
		GameManager.load_game_scene()
