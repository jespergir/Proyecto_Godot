class_name SuperficieSala1 extends Sala

func _ready() -> void:
	ancho = $GestionMapa/FinSuperiorSala.position.x - $GestionMapa/InicioSuperiorSala.position.x
	alto = $GestionMapa/FinSuperiorSala.position.y - $GestionMapa/FinInferiorSala.position.y

func calcular_dimensiones():
	ancho = $GestionMapa/FinSuperiorSala.position.x - $GestionMapa/InicioSuperiorSala.position.x
	alto = $GestionMapa/FinSuperiorSala.position.y - $GestionMapa/FinInferiorSala.position.y


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
