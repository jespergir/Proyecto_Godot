# Este script va en un Area2D al borde de cada sala
extends Node2D

@export var next_room: String
@onready var inicio_superior_sala : Marker2D = $InicioSuperiorSala
@onready var inicio_inferior_sala : Marker2D = $InicioInferiorSala
@onready var fin_superior_sala : Marker2D = $FinSuperiorSala
@onready var fin_inferior_sala : Marker2D = $FinInferiorSala

var loaded := false
