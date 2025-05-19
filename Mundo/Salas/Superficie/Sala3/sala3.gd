class_name Sala3 extends Sala

var namesala = "sala_1_1"

func _ready() -> void:
	ancho = $GestionMapaSala3/FinSuperiorSala.position.x - $GestionMapaSala3/InicioSuperiorSala.position.x
	alto = $GestionMapaSala3/FinSuperiorSala.position.y - $GestionMapaSala3/FinInferiorSala.position.y

func calcular_dimensiones():
	ancho = $GestionMapaSala3/FinSuperiorSala.position.x - $GestionMapaSala3/InicioSuperiorSala.position.x
	alto = $GestionMapaSala3/FinSuperiorSala.position.y - $GestionMapaSala3/FinInferiorSala.position.y
