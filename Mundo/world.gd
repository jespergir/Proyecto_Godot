extends Node2D

@onready var protagonista : Protagonista = $Protagonista
@onready var pantalla_carga = $PantallaCarga
@onready var cargando = $Cargando

#Se encarga de preparar la ecena
func _ready() -> void:
	protagonista.hud = $Hud
	WorldManager.protagonista = $Protagonista
	SaveManager.protagonista = $Protagonista
	
	cargando.process_mode = Node.PROCESS_MODE_ALWAYS
	WorldManager.reset_world()
	
	if WorldManager.new_game:
		WorldManager.load_room_by_position("res://Mundo/Salas/Superficie/Sala1/Superficie_Sala1.tscn", Vector2(0,0))
	get_tree().paused = not get_tree().paused
	cargando.start()

# Cuando termina de cargar (1s, quita la pausa y oculta la pantalla de carga)
func _on_cargando_timeout() -> void:
	get_tree().paused = not get_tree().paused
	pantalla_carga.visible = false
