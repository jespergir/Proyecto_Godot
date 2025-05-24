extends CanvasLayer

# Referencia al rectángulo de color de fondo
@onready var color_rect = $ColorRect

# Colores entre los que se alterna el fondo
var color1 = Color.DARK_VIOLET
var color2 = Color.DARK_SLATE_BLUE
var color3 = Color.GOLDENROD

# Color actualmente seleccionado
var selected

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS #Hace que la pantalla de fin no se pause
	color_rect.modulate = color1 #Color inicial del fondo
	selected = color1 #Guarda el color actual

#Función para alternar entre los tres colores
func change_color():
	if selected == color1:
		color_rect.modulate = color2
		selected = color2
	elif selected == color2:
		color_rect.modulate = color3
		selected = color3
	else:
		color_rect.modulate = color1
		selected = color1

#Al terminar el temporizador, cambia el color del fondo
func _on_timer_timeout() -> void:
	change_color()
