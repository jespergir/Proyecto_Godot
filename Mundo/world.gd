extends Node2D

@onready var pantalla_carga = $PantallaCarga
@onready var cargando = $Cargando

#Se encarga de preparar la ecena
func _ready() -> void:
	cargando.process_mode = Node.PROCESS_MODE_ALWAYS
	GameState.world = self

# Cuando termina de cargar (1s, quita la pausa y oculta la pantalla de carga)
func _on_cargando_timeout() -> void:
	get_tree().paused = not get_tree().paused
	pantalla_carga.visible = false
