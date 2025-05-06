class_name SuperficieSala1 extends Sala

func _ready() -> void:
	ancho = $GestionMapa/FinSuperiorSala.position.x - $GestionMapa/InicioSuperiorSala.position.x
	alto = $GestionMapa/FinSuperiorSala.position.y - $GestionMapa/FinInferiorSala.position.y

func calcular_dimensiones():
	ancho = $GestionMapa/FinSuperiorSala.position.x - $GestionMapa/InicioSuperiorSala.position.x
	alto = $GestionMapa/FinSuperiorSala.position.y - $GestionMapa/FinInferiorSala.position.y
