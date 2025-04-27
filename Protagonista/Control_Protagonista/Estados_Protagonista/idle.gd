class_name Idle extends PlayerBaseState

func start():	
	if not protagonista.animated_sprite.is_playing() or protagonista.animated_sprite.animation != "Idle":
		protagonista.animated_sprite.play("Idle")

func on_physics_process(delta: float) -> void:
	
	# La velocidad de la protagonista en x es 0
	protagonista.velocity.x = move_toward(protagonista.velocity.x, 0, protagonista.SPEED)
	
#region Attack1
	# Si se pulsa la acción saltar, la almacena en búfer y si pasa poco rato hasta que se puede saltar, cambia a Saltar
	if Input.is_action_just_pressed("Attack1"):
		state_machine.change_to("Attack1")
		return
#endregion
	
#region Walk
	# Si se pulsa Izquierda o Derecha, cambia a walk
	var direction := Input.get_axis("Left", "Right")
	if direction:
		state_machine.change_to("Walk")
		return
#endregion
	
#region Jump
	# Si se pulsa la acción saltar, la almacena en búfer y si pasa poco rato hasta que se puede saltar, cambia a Saltar
	if protagonista.protagonista.jump_buffer_timer > 0 and protagonista.protagonista.coyote_timer > 0:
		state_machine.change_to("Jump")
		return
#endregion
	
#region Fall
	# Después de un segundo de caída (al caer mientras andas)
	if protagonista.velocity.y>=0 and (!protagonista.raycast_suelo1.is_colliding() or !protagonista.raycast_suelo2.is_colliding()) and protagonista.protagonista.coyote_timer:
		protagonista.falling_time +=delta
		if protagonista.falling_time>0.2:
			protagonista.falling_time=0
			state_machine.change_to("Fall")
			return
#endregion
	
#region Land
	# Si la velocidad en y es 0 y la protagonista está en el suelo, cambia a Land (al caer mientras andas)
	if protagonista.velocity.y > 0 and (protagonista.raycast_suelo1.is_colliding() or protagonista.raycast_suelo2.is_colliding()):
		state_machine.change_to("Land")
		return
#endregion
	
#region Damage
	if protagonista.damage_just_received:
		state_machine.change_to("Damage")
		return
#endregion
	
	handle_states(delta)
	protagonista.move_and_slide()
