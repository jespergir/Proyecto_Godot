extends Node2D

@onready var protagonista : Protagonista = $Protagonista

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	protagonista.hud = $Hud
	WorldManager.protagonista = $Protagonista  # Usa la ruta real hacia tu nodo jugador
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
