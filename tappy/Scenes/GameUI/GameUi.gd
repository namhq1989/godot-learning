extends Control

@onready var score_label: Label = $MarginContainer/ScoreLabel
@onready var game_over_label: Label = $MarginContainer/GameOverLabel
@onready var press_space_label: Label = $MarginContainer/PressSpaceLabel
@onready var change_cta_timer: Timer = $ChangeCTATimer


var _can_press: bool = false
var _score: int = 0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	


func _enter_tree() -> void:
	SignalHub.on_point_scored.connect(_on_point_scored)
	SignalHub.on_plane_died.connect(_on_plane_died)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit") and event.is_echo() == false:
		GameManager.load_main_scence()
	elif _can_press and true and event.is_action_pressed("jump"):
		ScoreManager.high_score = _score
		GameManager.load_main_scence()


func _on_plane_died() -> void:
	game_over_label.show()
	
	change_cta_timer.start()


func _on_change_cta_timer_timeout() -> void:
	_can_press = true
	game_over_label.hide()
	press_space_label.show()
	
func _on_point_scored() -> void:
	_score += 1
	
	score_label.text = "%04d" % _score
