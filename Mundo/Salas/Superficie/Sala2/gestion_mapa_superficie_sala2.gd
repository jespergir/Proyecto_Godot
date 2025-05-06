# Este script va en un Area2D al borde de cada sala
extends Node2D

@export var next_room: String
@onready var inicio_superior_sala : Marker2D = $InicioSuperiorSala
@onready var inicio_inferior_sala : Marker2D = $InicioInferiorSala
@onready var fin_superior_sala : Marker2D = $FinSuperiorSala
@onready var fin_inferior_sala : Marker2D = $FinInferiorSala

var loaded := false

func _on_area_salida_derecha_body_entered(body: Node2D) -> void:
	next_room = "res://Mundo/Salas/Superficie/Sala1/Sala1.tscn"
	if body.is_in_group("Protagonista") and loaded:
		return  # Evita cargar dos veces
	#loaded = true
	WorldManager.load_room(next_room, get_parent().global_position, get_parent().ancho, WorldManager.posiciones.Derecha)


func _on_area_salida_izquierda_body_entered(body: Node2D) -> void:
	next_room = "res://Mundo/Salas/Sala3/Sala3.tscn"
	if body.is_in_group("Protagonista") and loaded:
		return  # Evita cargar dos veces
	#loaded = true
	WorldManager.load_room(next_room, get_parent().global_position, get_parent().ancho, WorldManager.posiciones.Izquierda)
