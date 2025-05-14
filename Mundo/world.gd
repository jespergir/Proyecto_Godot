extends Node2D

@onready var protagonista : Protagonista = $Protagonista
@onready var pantalla_carga = $PantallaCarga
@onready var cargando = $Cargando
@onready var hud = $Hud

#Se encarga de preparar la ecena
func _ready() -> void:
	WorldManager.reset_world()
	cargando.process_mode = Node.PROCESS_MODE_ALWAYS
	protagonista.hud = hud
	WorldManager.protagonista = $Protagonista
	SaveManager.protagonista = $Protagonista

	if WorldManager.new_game:
		WorldManager.load_room_by_position("res://Mundo/Salas/Superficie/Sala1/Superficie_Sala1.tscn", Vector2(0,0))
	get_tree().paused = not get_tree().paused
	cargando.start()

# Cuando termina de cargar (1s, quita la pausa y oculta la pantalla de carga)
func _on_cargando_timeout() -> void:
	get_tree().paused = not get_tree().paused
	pantalla_carga.visible = false
