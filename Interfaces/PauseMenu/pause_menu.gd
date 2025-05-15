extends CanvasLayer

@onready var contenedor : VBoxContainer = $Control/VBoxContainer
@onready var boton_reanudar : Button = $Control/VBoxContainer/BotonReanudar
@onready var timer : Timer = $Timer

#Prepara la escena, evita que sea pausable y hace focuseables los botones.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for boton in contenedor.get_children():
		if boton is Button:
			boton.focus_mode = Control.FOCUS_ALL

#Cuando se pulsa el botón de pausa, pausa el juego
func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("Pause"):
		toggle_pause()

#Si se pulsa el botón reanudar, inicia el temporizador.
func _on_boton_reanudar_button_down() -> void:
	timer.start()

#Espera 0.1 segundos y deshace la pausa.
func _on_timer_timeout() -> void:
	toggle_pause()

#Si se pulsa el botón, pausa el juego, resetea el mundo, cambia la escena, carga la partida y fija el estado de los booleanos.
func _on_boton_cargar_button_down() -> void:
	toggle_pause()
	WorldManager.reset_world()
	get_tree().change_scene_to_file("res://Mundo/World.tscn")
	SaveManager.load_game()
	WorldManager.new_game = false
	WorldManager.jugando = true

#Si se pulsa, sale del juego
func _on_boton_salir_button_down() -> void:
	get_tree().quit()

#Hace o deshace la pausa
func toggle_pause():
	
	get_tree().paused = not get_tree().paused
	visible = get_tree().paused
	
	if visible:
		await get_tree().process_frame
		boton_reanudar.grab_focus()
