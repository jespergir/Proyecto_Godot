extends CanvasLayer

# Referencias a los sonidos del menú
@onready var audio_down = $AudioStreamPlayerDown
@onready var audio_focus = $AudioStreamPlayerFocus

# Referencias a los botones del menú
@onready var contenedor : VBoxContainer = $Control/VBoxContainer
@onready var boton_comenzar : Button = $Control/VBoxContainer/BotonComenzar

var first = true #Evita reproducir el sonido de focus la primera vez

#Prepara la escena start screen
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS #Evita que la escena se pause

	# Activa el enfoque para todos los botones y enfoca el botón "Comenzar"
	for boton in contenedor.get_children():
		if boton is Button:
			boton.focus_mode = Control.FOCUS_ALL
	boton_comenzar.grab_focus()

#Cuando se pulsa el botón comenzar, reproduce audio y lanza nueva partida
func _on_boton_comenzar_button_down() -> void:
	audio_down.play()
	await audio_down.finished
	WorldManager.start_game()

#Cuando se pulsa el botón cargar, reproduce audio y carga partida
func _on_boton_cargar_button_down() -> void:
	audio_down.play()
	await audio_down.finished
	WorldManager.load_game()

#Cuando se pulsa el botón salir, reproduce audio y cierra el juego
func _on_boton_salir_button_down() -> void:
	audio_down.play()
	await audio_down.finished
	get_tree().quit()

#Reproduce sonido al enfocar un botón (excepto la primera vez)
func _on_focus_entered() -> void:
	if not first:
		audio_focus.play()
	first = false
