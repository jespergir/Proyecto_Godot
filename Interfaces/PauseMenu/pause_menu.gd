extends CanvasLayer

@onready var contenedor : VBoxContainer = $Control/VBoxContainer
@onready var boton_reanudar : Button = $Control/VBoxContainer/BotonReanudar
@onready var timer : Timer = $Timer

#Prepara la escena, evita que sea pausable y hace focuseables los botones.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	GameState.connect("juego_pausado", Callable(self, "mostrar_menu_pausa"))
	GameState.connect("juego_reanudado", Callable(self, "mostrar_menu_pausa"))
	for boton in contenedor.get_children():
		if boton is Button:
			boton.focus_mode = Control.FOCUS_ALL

#Si se pulsa el botón reanudar, inicia el temporizador.
func _on_boton_reanudar_button_down() -> void:
	timer.start()

#Espera 0.1 segundos y deshace la pausa.
func _on_timer_timeout() -> void:
	GameState.toggle_pause()

#Si se pulsa el botón, pausa el juego, resetea el mundo, cambia la escena, carga la partida y fija el estado de los booleanos.
func _on_boton_cargar_button_down() -> void:
	GameState.toggle_pause()
	WorldManager.load_game()

#Si se pulsa, sale del juego
func _on_boton_salir_button_down() -> void:
	get_tree().quit()

#Hace o deshace la pausa
func mostrar_menu_pausa():
	visible = get_tree().paused
	if visible:
		await get_tree().process_frame
		boton_reanudar.grab_focus()
