extends Node2D

# Referencias a nodos de la pantalla de carga
@onready var pantalla_carga = $PantallaCarga
@onready var cargando = $Cargando

#Se encarga de preparar la escena
func _ready() -> void:
	cargando.process_mode = Node.PROCESS_MODE_ALWAYS #Permite que el temporizador funcione aunque el juego esté pausado
	GameState.world = self #Guarda la referencia del mundo en GameState

#Cuando termina el temporizador (1s), despausa el juego y oculta la pantalla de carga
func _on_cargando_timeout() -> void:
	get_tree().paused = not get_tree().paused #Activa o desactiva la pausa
	pantalla_carga.visible = false #Oculta la pantalla de carga
