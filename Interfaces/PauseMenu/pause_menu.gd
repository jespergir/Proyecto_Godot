extends CanvasLayer

# Referencias a nodos UI y audio
@onready var contenedor : VBoxContainer = $Control/VBoxContainer
@onready var boton_reanudar : Button = $Control/VBoxContainer/BotonReanudar
@onready var timer : Timer = $Timer
@onready var audio_down = $AudioStreamPlayerDown
@onready var audio_focus = $AudioStreamPlayerFocus

var first = true #Controla que el primer focus no reproduzca sonido

#Prepara la escena, evita que sea pausable y hace focuseables los botones.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS #Permite que el menú funcione incluso en pausa

	#Conecta señales del GameState para mostrar/ocultar el menú de pausa
	GameState.connect("juego_pausado", Callable(self, "mostrar_menu_pausa"))
	GameState.connect("juego_reanudado", Callable(self, "mostrar_menu_pausa"))

	#Habilita el enfoque por teclado/controlador para cada botón
	for boton in contenedor.get_children():
		if boton is Button:
			boton.focus_mode = Control.FOCUS_ALL

#Si se pulsa el botón reanudar, reproduce audio y arranca un temporizador corto antes de reanudar
func _on_boton_reanudar_button_down() -> void:
	audio_down.play()
	await audio_down.finished
	timer.start()

#Espera 0.1 segundos (timer) y deshace la pausa
func _on_timer_timeout() -> void:
	GameState.toggle_pause()

#Carga la partida desde el menú de pausa
func _on_boton_cargar_button_down() -> void:
	audio_down.play()
	await audio_down.finished
	GameState.toggle_pause() #Primero despausa para evitar bugs
	WorldManager.load_game()

#Cierra el juego desde el menú de pausa
func _on_boton_salir_button_down() -> void:
	audio_down.play()
	await audio_down.finished
	get_tree().quit()

#Muestra el menú de pausa cuando el juego está pausado y enfoca el botón reanudar
func mostrar_menu_pausa():
	visible = get_tree().paused
	if visible:
		await get_tree().process_frame #Espera un frame para que pueda hacer focus correctamente
		boton_reanudar.grab_focus()

#Reproduce sonido de enfoque (excepto la primera vez)
func _on_focus_entered() -> void:
	if not first:
		audio_focus.play()
	first = false

#Callback vacío (por si se conecta desde el editor y se quiere evitar error)
func _on_audio_stream_player_down_finished() -> void:
	pass
