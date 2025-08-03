extends Node2D

const PipesScene = preload("res://Scenes/Pipes/Pipes.tscn")

@onready var plane: Tappy = $Plane
@onready var pipes_holder: Node2D = $PipesHolder
@onready var pipes_spawn_timer: Timer = $PipesSpawnTimer

const SPAWN_OFFSET_X = 100
const RANDOM_Y_RANGE = 150
const MIN_Y_DIFFERENCE = 50
const Y_ADJUSTMENT = 100

var previous_pipes_y: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_pipes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_pipes() -> void:
	var pipes = PipesScene.instantiate()
	pipes.position.x = get_viewport().get_visible_rect().size.x + SPAWN_OFFSET_X
	
	var viewport_y = get_viewport().get_visible_rect().size.y
	var new_y = viewport_y / 2 + randf_range(-RANDOM_Y_RANGE, RANDOM_Y_RANGE)
	if abs(new_y - previous_pipes_y) < MIN_Y_DIFFERENCE:
		if previous_pipes_y > viewport_y:
			new_y = previous_pipes_y - Y_ADJUSTMENT
		else:
			new_y = previous_pipes_y + Y_ADJUSTMENT
	
	pipes.position.y = new_y
	previous_pipes_y = new_y
	
	pipes_holder.add_child(pipes)

func _on_pipes_spawn_timer_timeout() -> void:
	spawn_pipes()


func _on_plane_died() -> void:
	get_tree().paused = true  
