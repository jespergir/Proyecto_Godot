extends Node

signal protagonista_ready
signal world_ready
signal hud_ready

signal juego_pausado
signal juego_reanudado

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

#Cuando se pulsa el botón de pausa, pausa el juego
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause"):
		toggle_pause()

func toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		emit_signal("juego_reanudado")
	else:
		get_tree().paused = true
		emit_signal("juego_pausado")
