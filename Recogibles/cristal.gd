extends RigidBody2D

# Referencias a los nodos internos del cristal
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite : Sprite2D = $Sprite2D
@onready var collision_shape : CollisionShape2D = $Area2D/CollisionShape2D
@onready var audio = $AudioStreamPlayer

#Cuando la protagonista entra en el área del cristal
func _on_area2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Protagonista"): #Solo se activa si el cuerpo es la protagonista
		recoger()

#Cuando termina la animación de desaparición, se elimina el nodo
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "Disapear":
		call_deferred("queue_free") #Hace desaparecer el item después de recogerlo

#Función que gestiona la recogida del cristal
func recoger():
	collision_shape.set_deferred("disabled", true) #Desactiva la colisión para que no pueda recogerse de nuevo
	sprite.visible = false #Oculta el sprite normal
	animated_sprite.visible = true #Muestra el sprite animado
	audio.play() #Reproduce el sonido de recogida
	animated_sprite.play("Disapear") #Reproduce la animación de desaparición
