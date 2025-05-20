extends RigidBody2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite : Sprite2D = $Sprite2D
@onready var collision_shape : CollisionShape2D = $Area2D/CollisionShape2D
@onready var audio = $AudioStreamPlayer

func _on_area2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Protagonista"):
		recoger()

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "Disapear":
		await audio.finished
		call_deferred("queue_free") #Hacer desaparecer el item tras cogerlo.


func recoger():
	collision_shape.set_deferred("disabled", true)
	sprite.visible = false
	animated_sprite.visible = true
	audio.play()
	animated_sprite.play("Disapear")
