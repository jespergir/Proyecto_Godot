# Este script va en un Area2D al borde de cada sala
extends Node2D

# Ruta de la siguiente sala a cargar (puede configurarse desde el editor)
@export var next_room: String

# Referencias a los marcadores de los extremos de la sala actual (pueden usarse para cálculos de tamaño o posicionamiento)
@onready var inicio_superior_sala : Marker2D = $InicioSuperiorSala
@onready var inicio_inferior_sala : Marker2D = $InicioInferiorSala
@onready var fin_superior_sala : Marker2D = $FinSuperiorSala
@onready var fin_inferior_sala : Marker2D = $FinInferiorSala

# Flags para evitar cargas múltiples por dirección
var loaded_salida_derecha := false
var loaded_salida_izquierda := false
var loaded_salida_inferior := false
var loaded_salida_superior := false

#Cuando la protagonista entra por la salida derecha
func _on_area_salida_derecha_body_entered(body: Node2D) -> void:
	# Ruta de la sala vecina (aquí se puede parametrizar o calcular automáticamente si lo deseas)
	next_room = "res://Mundo/Salas/Superficie/Sala2/Superficie_Sala2.tscn"

	# Solo reacciona si el cuerpo pertenece a la protagonista
	if body.is_in_group("Protagonista") and loaded_salida_derecha:
		return #Evita que la sala se cargue más de una vez

	# loaded_salida_derecha = true # ← Puedes descomentar esto para prevenir recarga posterior

	# Llama al WorldManager para cargar la sala nueva en la dirección adecuada
	WorldManager.load_room(
		next_room,                        # Ruta de la sala
		get_parent().global_position,    # Posición de la sala actual
		get_parent().ancho,              # Ancho de la sala actual
		get_parent().alto,               # Alto de la sala actual
		WorldManager.posiciones.Derecha  # Dirección en la que se debe cargar
	)
