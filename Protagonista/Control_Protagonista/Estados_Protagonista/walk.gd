class_name Walk extends PlayerStatesBaseState

func on_physics_process(delta: float) -> void:
	
	if protagonista.jump_buffer_timer > 0 and protagonista.coyote_timer > 0:
		state_machine.change_to("Jump")
		return	
		
	# Controlar la dirección mientras salta
	var direction := Input.get_axis("Left", "Right")
	if direction:
		protagonista.velocity.x = direction * Protagonista.SPEED
		protagonista.animated_sprite.scale.x = sign(direction)
		protagonista.attack1.scale.x = sign(direction)
		protagonista.animated_sprite.play("Walk")
	else:
		protagonista.velocity.x = move_toward(protagonista.velocity.x, 0, protagonista.SPEED)

		# Después de un segundo de caída, cambiar a Fall
	if protagonista.velocity.y>=0 and (!protagonista.raycast_suelo1.is_colliding() or !protagonista.raycast_suelo2.is_colliding()) and protagonista.coyote_timer<=0:
		protagonista.falling_time +=delta
		if protagonista.falling_time>0.2:
			protagonista.falling_time=0
			state_machine.change_to("Fall")
			return
			
	if  Input.is_action_just_pressed("Attack1"):
		state_machine.change_to("Attack1")
		return
			
	if not Input.get_axis("Left", "Right"):
		state_machine.change_to("Idle")
		return
		
	handle_states(delta)
	protagonista.move_and_slide()
