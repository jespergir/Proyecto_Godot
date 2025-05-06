class_name Walk extends PlayerBaseState

func on_physics_process(delta: float) -> void:

#region Walk
	# Controlar la dirección al andar
	var direction := Input.get_axis("Left", "Right")
	if direction:
		protagonista.velocity.x = direction * Protagonista.SPEED
		protagonista.animated_sprite.scale.x = sign(direction)
		protagonista.attack1.scale.x = sign(direction)
		protagonista.animated_sprite.play("Walk")
	else:
		protagonista.velocity.x = move_toward(protagonista.velocity.x, 0, protagonista.SPEED)
#endregion
	
#region Jump
	if protagonista.protagonista.jump_buffer_timer > 0 and protagonista.protagonista.coyote_timer > 0:
		state_machine.change_to("Jump")
		return	
#endregion
	
#region Fall
	# Después de un segundo de caída (al caer mientras andas)
	if protagonista.velocity.y>=0 and (!protagonista.raycast_suelo1.is_colliding() or !protagonista.raycast_suelo2.is_colliding()) and protagonista.protagonista.coyote_timer<=0:
		protagonista.falling_time +=delta
		if protagonista.falling_time>0.2:
			protagonista.falling_time=0
			state_machine.change_to("Fall")
			return
#endregion
	
#region Land
	# Si la velocidad en y es 0 y la protagonista está en el suelo, cambia a Land (al caer mientras andas)
	if protagonista.velocity.y > 0 and (protagonista.raycast_suelo1.is_colliding() and protagonista.raycast_suelo2.is_colliding()):
		state_machine.change_to("Land")
		return
#endregion
	
#region Attack1
	if  Input.is_action_just_pressed("Attack1"):
		state_machine.change_to("Attack1")
		return
#endregion
	
#region Damage
	if protagonista.damage_just_received:
		state_machine.change_to("Damage")
		return
#endregion
	
#region Idle
	if not Input.get_axis("Left", "Right"):
		state_machine.change_to("Idle")
		return
#endregion
	
	handle_states(delta)
	protagonista.move_and_slide()
