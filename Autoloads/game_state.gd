extends Node

#Señales que se emiten cuando las referencias están listas
signal protagonista_ready
signal world_ready
signal hud_ready
signal audio_ready

#Señales para controlar el estado de pausa del juego
signal juego_pausado
signal juego_reanudado

#Referencia a la protagonista. Al asignarla, se emite su señal correspondiente
var protagonista:
	set(value):
		protagonista = value
		emit_signal("protagonista_ready")
	get:
		return protagonista

#Referencia al mundo. Al asignarla, se emite su señal correspondiente
var world:
	set(value):
		world = value
		emit_signal("world_ready")
	get:
		return world

#Referencia al HUD. Al asignarla, se emite su señal correspondiente
var hud:
	set(value):
		hud = value
		emit_signal("hud_ready")
	get:
		return hud

#Referencia al audio. Al asignarla, se emite su señal correspondiente
var audio :AudioStreamPlayer:
	set(value):
		audio = value
		emit_signal("audio_ready")
	get:
		return audio

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS #Evita que el nodo se pause, necesario para que GameState siempre esté activo

#Detecta entrada del jugador para pausar o reanudar el juego
func _unhandled_input(_event: InputEvent):
	if Input.is_action_just_pressed("Pause"): #Si se presiona la tecla de pausa, cambia el estado
		toggle_pause()

func toggle_pause():
	if get_tree().paused:
		get_tree().paused = false #Reanuda el juego y emite la señal correspondiente
		emit_signal("juego_reanudado")
	else:
		get_tree().paused = true #Pausa el juego y emite la señal correspondiente
		emit_signal("juego_pausado")
