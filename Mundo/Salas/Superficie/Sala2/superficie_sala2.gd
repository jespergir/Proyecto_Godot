class_name SuperficieSala2 extends Sala

@onready var puerta = $GestionMapaSala2/Puerta
@onready var boton = $Boton

var namesala = "sala_1_0"

func _ready() -> void:
	ancho = $GestionMapaSala2/FinSuperiorSala.position.x - $GestionMapaSala2/InicioSuperiorSala.position.x
	alto = $GestionMapaSala2/FinSuperiorSala.position.y - $GestionMapaSala2/FinInferiorSala.position.y
	boton.connect("button_down", Callable(self, "_on_button_down"))

func calcular_dimensiones():
	ancho = $GestionMapaSala2/FinSuperiorSala.position.x - $GestionMapaSala2/InicioSuperiorSala.position.x
	alto = $GestionMapaSala2/FinSuperiorSala.position.y - $GestionMapaSala2/FinInferiorSala.position.y

func _on_button_down():
	puerta.queue_free()
