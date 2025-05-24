class_name SuperficieSala1 extends Sala

# Identificador único de la sala para el sistema de minimapa
var namesala = "sala_0_0"

#Al iniciar la sala, se calculan sus dimensiones usando los marcadores definidos en GestionMapa
func _ready() -> void:
	ancho = $GestionMapa/FinSuperiorSala.position.x - $GestionMapa/InicioSuperiorSala.position.x
	alto = $GestionMapa/FinSuperiorSala.position.y - $GestionMapa/FinInferiorSala.position.y

#Función reutilizable para recalcular las dimensiones si fuera necesario
func calcular_dimensiones():
	ancho = $GestionMapa/FinSuperiorSala.position.x - $GestionMapa/InicioSuperiorSala.position.x
	alto = $GestionMapa/FinSuperiorSala.position.y - $GestionMapa/FinInferiorSala.position.y
