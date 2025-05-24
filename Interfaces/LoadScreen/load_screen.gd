extends CanvasLayer

# Referencia al rectángulo de color de fondo
@onready var color_rect = $ColorRect

# Color actualmente seleccionado
var selected

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS #Hace que la pantalla de fin no se pause
