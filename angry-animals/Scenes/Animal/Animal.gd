extends RigidBody2D

enum AnimalState {
	Ready,
	Drag,
	Release,
}

const DRAG_LIM_MAX: Vector2 = Vector2(0, 60)
const DRAG_LIM_MIN: Vector2 = Vector2(-60, 0)

@onready var arrow: Sprite2D = $Arrow
@onready var debug_label: Label = $DebugLabel
@onready var stretch_sound: AudioStreamPlayer2D = $StretchSound
@onready var launch_sound: AudioStreamPlayer2D = $LaunchSound


var _state: AnimalState = AnimalState.Ready
var _start: Vector2 = Vector2.ZERO
var _drag_start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO
var _arrow_scale_x: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_state()
	_update_debug_label()

#region signals

func _unhandled_input(event: InputEvent) -> void:
	if _state == AnimalState.Drag and event.is_action_released("drag"):
		call_deferred("_change_state", AnimalState.Release)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("drag") and _state == AnimalState.Ready:
		_change_state(AnimalState.Drag)
		_start_dragging()


func _on_sleeping_state_changed() -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node) -> void:
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	pass # Replace with function body.

#endregion


func _setup() -> void:
	arrow.hide()
	_arrow_scale_x = arrow.scale.x
	_start = position


#region state

func _update_state() -> void:
	match _state:
		AnimalState.Drag:
			_handle_dragging()
		AnimalState.Release:
			_start_release()


func _change_state(new_state: AnimalState) -> void:
	if _state == new_state:
		return
	
	_state = new_state
	
	_update_state()

#endregion

#region release

func _start_release() -> void:
	arrow.hide()
	launch_sound.play()
	freeze = false

#endregion

#region drag

func _start_dragging() -> void:
	arrow.show()
	_drag_start = get_global_mouse_position()


func _handle_dragging() -> void:
	var new_drag_vector: Vector2 = get_global_mouse_position() - _drag_start
	
	new_drag_vector = new_drag_vector.clamp(
		DRAG_LIM_MIN,
		DRAG_LIM_MAX,
	)
	
	var diff: Vector2 = new_drag_vector - _dragged_vector
	if diff.length() > 0 and stretch_sound.playing == false:
		stretch_sound.play()
	
	_dragged_vector = new_drag_vector
	position = _start + _dragged_vector

#endregion

#region misc

func _update_debug_label() -> void:
	var ds: String = "ST:%s SL:%s FR:%s\n" % [
		AnimalState.keys()[_state],
		sleeping,
		freeze,
	]
	ds += "_drag_start: %.1f, %.1f\n" % [_drag_start.x, _drag_start.y]
	ds += "_dragged_vector: %.1f, %.1f" % [_dragged_vector.x, _dragged_vector.y]
	
	debug_label.text = ds

#endregion
