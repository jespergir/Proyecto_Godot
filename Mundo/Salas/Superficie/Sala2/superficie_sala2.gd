class_name SuperficieSala2 extends Sala

# Referencias a los nodos importantes de la sala
@onready var puerta = $GestionMapaSala2/Puerta
@onready var boton = $Boton

# Identificador único de la sala para el minimapa
var namesala = "sala_1_0"

#Al iniciar la sala, se calculan sus dimensiones y se conecta el botón
func _ready() -> void:
	ancho = $GestionMapaSala2/FinSuperiorSala.position.x - $GestionMapaSala2/InicioSuperiorSala.position.x
	alto = $GestionMapaSala2/FinSuperiorSala.position.y - $GestionMapaSala2/FinInferiorSala.position.y

	boton.connect("button_down", Callable(self, "_on_button_down")) #Se conecta la señal del botón a la función correspondiente

#Función reutilizable para recalcular dimensiones si es necesario
func calcular_dimensiones():
	ancho = $GestionMapaSala2/FinSuperiorSala.position.x - $GestionMapaSala2/InicioSuperiorSala.position.x
	alto = $GestionMapaSala2/FinSuperiorSala.position.y - $GestionMapaSala2/FinInferiorSala.position.y

#Cuando se pulsa el botón, se elimina la puerta
func _on_button_down():
	puerta.queue_free()
