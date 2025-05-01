class_name Sala3 extends Sala

func _ready() -> void:
	ancho = $GestionMapa/FinSuperiorSala.position.x - $GestionMapa/InicioSuperiorSala.position.x
	alto = $GestionMapa/FinSuperiorSala.position.y - $GestionMapa/FinInferiorSala.position.y
