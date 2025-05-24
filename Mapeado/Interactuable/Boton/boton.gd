class_name Boton extends StaticBody2D

# Referencias a los nodos de animación del botón
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer

# Señal que se emite cuando el botón es pulsado
signal button_down

# Flag que evita que se pulse más de una vez
var pulsado := false

#Función que se ejecuta al pulsar el botón
func pulsar_boton():
	pulsado = true #Marca el botón como pulsado
	animated_sprite.play("Boton") #Reproduce la animación del sprite (presión del botón)
	animation_player.play("pulsar") #Reproduce la animación del AnimationPlayer (efecto visual)
	emit_signal("button_down") #Emite la señal para que otros nodos reaccionen

#Detecta si la protagonista entra en el área del botón
func _on_area_2d_body_entered(body: Node2D) -> void:
	if pulsado:
		return #Evita múltiples activaciones
	if body.is_in_group("Protagonista"): #Si el cuerpo pertenece al grupo "Protagonista", activa el botón
		pulsar_boton()
