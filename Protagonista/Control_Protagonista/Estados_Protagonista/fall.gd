class_name Fall extends PlayerStatesBaseState

func on_physics_process(delta: float) -> void:
	
	# Controlar la dirección mientras cae
	var direction := Input.get_axis("Left", "Right")
	if direction:
		protagonista.velocity.x = direction * Protagonista.SPEED
		protagonista.animated_sprite.scale.x = sign(direction)
	else:
		protagonista.velocity.x = move_toward(protagonista.velocity.x, 0, protagonista.SPEED)
	
	# Si la velocidad en y es mayor de 0 y el raycast no detecta el suelo, repodruce falling
	if protagonista.velocity.y>=0 and !(protagonista.raycast_suelo1.is_colliding() or protagonista.raycast_suelo2.is_colliding()):
			protagonista.animated_sprite.play("Fall")
			protagonista.falling_time=0

	if protagonista.jump_buffer_timer > 0 and protagonista.coyote_timer > 0:
		state_machine.change_to("Jump")
		return

	# Si la velocidad en y es 0 y la protagonista está en el suelo, cambia a Land
	if protagonista.velocity.y > 0 and (protagonista.raycast_suelo1.is_colliding() or protagonista.raycast_suelo2.is_colliding()):
		state_machine.change_to("Land")
		return
	
	handle_states(delta)
	protagonista.move_and_slide()
