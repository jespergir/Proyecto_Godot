# Este script va en un Area2D al borde de cada sala
extends Area2D

@export var next_room: String = "res://Mundo/Salas/Sala2/Sala2.tscn"
@onready var marker_salida : Marker2D = get_node("../Salidas/SalidaDerecha")
#@onready var offset_position: Vector2 = marker_salida.position  # Posición relativa donde debe aparecer la nueva sala

var loaded := false

func _on_body_entered(body):
	if body.is_in_group("Protagonista") and loaded:
		return  # Evita cargar dos veces
	loaded = true
	WorldManager.load_room(next_room, global_position + marker_salida.position)
