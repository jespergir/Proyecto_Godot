extends Node

signal protagonista_ready
signal world_ready
signal hud_ready

var protagonista:
	set(value):
		protagonista = value
		emit_signal("protagonista_ready")
	get:
		return protagonista
var world:
	set(value):
		world = value
		emit_signal("world_ready")
	get:
		return world
var hud:
	set(value):
		hud = value
		emit_signal("hud_ready")
	get:
		return hud



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
