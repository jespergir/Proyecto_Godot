class_name Sala3 extends Sala

# Identificador único de la sala para el sistema de minimapa
var namesala = "sala_1_1"

#Al iniciar la sala, se calculan sus dimensiones
func _ready() -> void:
	ancho = $GestionMapaSala3/FinSuperiorSala.position.x - $GestionMapaSala3/InicioSuperiorSala.position.x
	alto = $GestionMapaSala3/FinSuperiorSala.position.y - $GestionMapaSala3/FinInferiorSala.position.y

#Función para recalcular las dimensiones de la sala (por si se necesita más adelante)
func calcular_dimensiones():
	ancho = $GestionMapaSala3/FinSuperiorSala.position.x - $GestionMapaSala3/InicioSuperiorSala.position.x
	alto = $GestionMapaSala3/FinSuperiorSala.position.y - $GestionMapaSala3/FinInferiorSala.position.y
