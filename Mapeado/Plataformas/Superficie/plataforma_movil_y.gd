extends Path2D

# Referencia al sprite animado de la plataforma
@onready var animated_sprite : AnimatedSprite2D = $PathFollow2D/AnimatableBody2D/AnimatedSprite2D

# Flags para controlar la dirección del movimiento
var bajando = false
var subiendo = false

#Función para hacer que la plataforma suba
func subir():
	animated_sprite.play("Subir") #Reproduce la animación de subida
	subiendo = true
	bajando = false

#Función para hacer transición a la subida (solo si no está subiendo ya)
func transicion_subir():
	if not subiendo:
		animated_sprite.play("TansicionSubir") #Reproduce animación de transición

#Función para hacer que la plataforma baje
func bajar():
	animated_sprite.play("Bajar") #Reproduce la animación de bajada
	bajando = true
	subiendo = false

#Función para hacer transición a la bajada (solo si no está bajando ya)
func transicion_bajar():
	if not bajando:
		animated_sprite.play("TransicionBajar") #Reproduce animación de transición
