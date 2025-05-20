class_name EnemigoPeepossIdle extends EnemigoPeepossBaseState

func enter():
	enemigo.velocity = Vector2.ZERO
	if enemigo.Animations.has_node("AnimatedSpriteBoss"):
		enemigo.Animations.get_node("AnimatedSpriteBoss").play("idle")

func physics_process(delta):
	# El jefe no hace nada hasta que se active
	pass

func _on_area_start_body_entered(body: Node2D) -> void:
	if body.name == "Protagonista":
		state_machine.change_to("Move") # Pasamos al siguiente estado: movimiento
		enemigo.area_start_collision.disabled = true
