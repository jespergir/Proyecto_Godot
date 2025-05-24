# Autoload encargado de gestionar el minimapa
extends Node

# Diccionario con las salas visitadas
var salas_visitadas: Dictionary = {}

# ID de la sala actual
var sala_actual: String = ""

# Referencia al nodo del minimapa (de tipo Control)
var minimap_node: Control = null

# Diccionario que asigna a cada ID de sala una posición en el minimapa
var mapa_salas := {
	"sala_0_0": Vector2(0, 0),
	"sala_1_0": Vector2(1, 0),
	"sala_1_1": Vector2(1, 1),
	# ... etc ...
}

func set_minimap_node(node):
	minimap_node = node
	if minimap_node:
		# Se actualiza el nodo del minimapa con los datos actuales
		minimap_node.salas_visitadas = salas_visitadas.duplicate()
		minimap_node.sala_actual = sala_actual
		# Fuerza el centrado y el redibujado del minimapa una vez cargados los datos
		minimap_node.centrar_y_redibujar_minimapa()

func set_sala_actual(id_sala: String):
	sala_actual = id_sala #Actualiza la sala actual
	salas_visitadas[id_sala] = true #Marca la sala como visitada

	if minimap_node:
		# Actualiza el nodo del minimapa con los nuevos datos
		minimap_node.sala_actual = sala_actual
		minimap_node.salas_visitadas = salas_visitadas.duplicate()
		minimap_node.centrar_y_redibujar_minimapa() #Redibuja y centra el minimapa
