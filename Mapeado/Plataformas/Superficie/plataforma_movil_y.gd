extends Path2D

@onready var animated_sprite : AnimatedSprite2D = $PathFollow2D/AnimatableBody2D/AnimatedSprite2D

var bajando = false
var subiendo = false

func subir():
	animated_sprite.play("Subir")
	subiendo = true
	bajando = false
	
func transicion_subir():
	if not subiendo:
		animated_sprite.play("TansicionSubir")
	
func bajar():
	animated_sprite.play("Bajar")
	bajando = true
	subiendo = false
	
func transicion_bajar():
	if not bajando:
		animated_sprite.play("TransicionBajar")
