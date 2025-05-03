class_name Land extends PlayerBaseState

func on_physics_process(delta: float) -> void:
#region Land
	# Si la velocidad en y es mayor que 0 y el raycast está colistionando, aterriza
	if protagonista.velocity.y >= 0 and (protagonista.raycast_suelo1.is_colliding() or protagonista.raycast_suelo2.is_colliding()):
		protagonista.animated_sprite.play("Land")
#endregion
#region MoveX
	# Controla la dirección en x mientras se aterriza
	var direction := Input.get_axis("Left", "Right")
	if direction:
		protagonista.velocity.x = direction * Protagonista.SPEED
		protagonista.animated_sprite.scale.x = sign(direction)
	else:
		protagonista.velocity.x = move_toward(protagonista.velocity.x, 0, protagonista.SPEED)
#endregion
	
#region Damage
	if protagonista.damage_just_received:
		state_machine.change_to("Damage")
		return
#endregion
	
#region Jump
	if protagonista.protagonista.jump_buffer_timer > 0 and protagonista.protagonista.coyote_timer > 0:
		state_machine.change_to("Jump")
		return
#endregion
	
#region Attack1
	# Si se pulsa la acción saltar, la almacena en búfer y si pasa poco rato hasta que se puede saltar, cambia a Saltar
	if Input.is_action_just_pressed("Attack1"):
		state_machine.change_to("Attack1")
		return
#endregion
	handle_states(delta)
	protagonista.move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	if protagonista.animated_sprite.animation == "Land":
			state_machine.change_to("Idle")
