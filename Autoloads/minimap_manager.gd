# Autoloads/minimap_manager.gd
extends Node

var salas_visitadas: Dictionary = {}
var sala_actual: String = ""
var minimap_node: Control = null
var mapa_salas := {
	"sala_0_0": Vector2(0, 0),
	"sala_1_0": Vector2(1, 0),
	# ... etc ...
}

func set_minimap_node(node):
	minimap_node = node
	if minimap_node:
		minimap_node.salas_visitadas = salas_visitadas.duplicate()
		minimap_node.sala_actual = sala_actual
		# Aquí es donde fuerzas el centrado después de tener los datos
		minimap_node.centrar_y_redibujar_minimapa()

func set_sala_actual(id_sala: String):
	sala_actual = id_sala
	salas_visitadas[id_sala] = true
	if minimap_node:
		minimap_node.sala_actual = sala_actual
		minimap_node.salas_visitadas = salas_visitadas.duplicate()
		minimap_node.centrar_y_redibujar_minimapa()
