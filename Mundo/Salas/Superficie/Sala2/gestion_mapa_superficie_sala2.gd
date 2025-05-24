# Este script va en un Area2D al borde de cada sala
extends Node2D

# Ruta de la siguiente sala (puede modificarse desde el editor si se quiere)
@export var next_room: String

# Marcadores que definen los límites de la sala
@onready var inicio_superior_sala : Marker2D = $InicioSuperiorSala
@onready var inicio_inferior_sala : Marker2D = $InicioInferiorSala
@onready var fin_superior_sala : Marker2D = $FinSuperiorSala
@onready var fin_inferior_sala : Marker2D = $FinInferiorSala

# Flag para evitar carga múltiple
var loaded := false

#Cuando la protagonista entra por la salida izquierda
func _on_area_salida_izquierda_body_entered(body: Node2D) -> void:
	next_room = "res://Mundo/Salas/Superficie/Sala1/Superficie_Sala1.tscn" #Ruta a sala 1
	if body.is_in_group("Protagonista") and loaded:
		return #Evita carga doble
	#loaded = true

	#Carga la sala 1 hacia la izquierda de la actual
	WorldManager.load_room(
		next_room,
		get_parent().global_position,
		get_parent().ancho,
		get_parent().alto,
		WorldManager.posiciones.Izquierda
	)

#Cuando la protagonista entra por la salida derecha
func _on_area_salida_derecha_body_entered(body: Node2D) -> void:
	next_room = "res://Mundo/Salas/Subsuelo/Sala3/Superficie_Sala3.tscn" #Ruta a sala 3
	if body.is_in_group("Protagonista") and loaded:
		return #Evita carga doble
	#loaded = true

	#Carga la sala 3 hacia abajo (aunque el nombre diga "derecha", usa posición Abajo)
	WorldManager.load_room(
		next_room,
		get_parent().global_position,
		get_parent().ancho,
		get_parent().alto,
		WorldManager.posiciones.Abajo
	)
