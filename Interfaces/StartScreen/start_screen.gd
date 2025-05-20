extends CanvasLayer

@onready var audio_down = $AudioStreamPlayerDown
@onready var audio_focus = $AudioStreamPlayerFocus
@onready var contenedor : VBoxContainer = $Control/VBoxContainer
@onready var boton_comenzar : Button = $Control/VBoxContainer/BotonComenzar

var first = true

#Prepara la escena start screen
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for boton in contenedor.get_children():
		if boton is Button:
			boton.focus_mode = Control.FOCUS_ALL
	boton_comenzar.grab_focus()

#Cuando se pulsa el botón comenzar, cambia de escena y cambia los booleanos correspondientes
func _on_boton_comenzar_button_down() -> void:
	audio_down.play()
	await audio_down.finished
	WorldManager.start_game()

#Cuando se pulsa el botón cargar, cambia de escena y cambia los booleanos correspondientes
func _on_boton_cargar_button_down() -> void:
	audio_down.play()
	await audio_down.finished
	WorldManager.load_game()
	

#Cuando se pulsa el botón salir, cierra el juego
func _on_boton_salir_button_down() -> void:
	audio_down.play()
	await audio_down.finished
	get_tree().quit()


func _on_focus_entered() -> void:
	if not first:
		audio_focus.play()
	first = false
