class_name SuperficieSala2 extends Sala

var namesala = "sala_1_0"

func _ready() -> void:
	ancho = $GestionMapaSala2/FinSuperiorSala.position.x - $GestionMapaSala2/InicioSuperiorSala.position.x
	alto = $GestionMapaSala2/FinSuperiorSala.position.y - $GestionMapaSala2/FinInferiorSala.position.y

func calcular_dimensiones():
	ancho = $GestionMapaSala2/FinSuperiorSala.position.x - $GestionMapaSala2/InicioSuperiorSala.position.x
	alto = $GestionMapaSala2/FinSuperiorSala.position.y - $GestionMapaSala2/FinInferiorSala.position.y
