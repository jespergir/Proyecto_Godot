extends CanvasLayer

@onready var contenedor : VBoxContainer = $Control/VBoxContainer
@onready var boton_comenzar : Button = $Control/VBoxContainer/BotonComenzar

#Prepara la escena start screen
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for boton in contenedor.get_children():
		if boton is Button:
			boton.focus_mode = Control.FOCUS_ALL
	boton_comenzar.grab_focus()

#Cuando se pulsa el botón comenzar, cambia de escena y cambia los booleanos correspondientes
func _on_boton_comenzar_button_down() -> void:
	get_tree().change_scene_to_file("res://Mundo/World.tscn")
	WorldManager.new_game=true
	WorldManager.jugando = true

#Cuando se pulsa el botón cargar, cambia de escena y cambia los booleanos correspondientes
func _on_boton_cargar_button_down() -> void:
	get_tree().change_scene_to_file("res://Mundo/World.tscn")
	SaveManager.load_game()
	WorldManager.new_game=false
	WorldManager.jugando = true

#Cuando se pulsa el botón salir, cierra el juego
func _on_boton_salir_button_down() -> void:
	get_tree().quit()
