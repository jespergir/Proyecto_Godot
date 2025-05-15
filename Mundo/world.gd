extends Node2D

@onready var protagonista : Protagonista = $Protagonista

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.world = self
	#protagonista.hud = $Hud
	#WorldManager.protagonista = $Protagonista
	#SaveManager.protagonista = $Protagonista
	WorldManager.load_room_by_position("res://Mundo/Salas/Superficie/Sala1/Superficie_Sala1.tscn", Vector2(0,0))
