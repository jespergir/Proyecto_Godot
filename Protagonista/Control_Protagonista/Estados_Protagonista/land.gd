extends PlayerFeaturesBaseState

func on_physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Saltar"):
		protagonista.jump_buffer_timer = protagonista.JUMP_BUFFER_TIME
	
	# Controla la dirección en x mientras se aterriza
	var direction := Input.get_axis("Izquierda", "Derecha")
	if direction:
		protagonista.velocity.x = direction * Protagonista.SPEED
		protagonista.animated_sprite.scale.x = sign(direction)
	else:
		protagonista.velocity.x = move_toward(protagonista.velocity.x, 0, protagonista.SPEED)
		
	if protagonista.jump_buffer_timer > 0 and protagonista.coyote_timer > 0:
		state_machine.change_to("Jump")
		return

		# Si la velocidad en y es mayor que 0 y el raycast está colistionando, aterriza
	if protagonista.velocity.y > 0 and (protagonista.raycast_suelo1.is_colliding() or protagonista.raycast_suelo2.is_colliding()):
		protagonista.animated_sprite.play("landing")
	
	handle_features(delta)
	handle_gravity(delta)
	protagonista.move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	if protagonista.animated_sprite.animation == "landing":
			state_machine.change_to("Idle")

func _on_Input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Saltar"):
		state_machine.change_to("Jump")
