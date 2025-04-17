extends PlayerFeaturesBaseState

func on_physics_process(delta: float) -> void:
		
	var direction := Input.get_axis("Izquierda", "Derecha")
	
	if direction:
		protagonista.velocity.x = direction * protagonista.SPEED
		if protagonista.velocity.x >0:
			protagonista.animated_sprite.scale = Vector2(1,1)
		else:
			protagonista.animated_sprite.scale = Vector2(-1,1)
		protagonista.animated_sprite.play("walking")
	else :#Si no hay dirección, para al personaje
		protagonista.velocity.x = move_toward(protagonista.velocity.x, 0, protagonista.SPEED)
		
		# Después de un segundo de caída, cambiar a Fall
	if protagonista.velocity.y>=0 and !(protagonista.raycast_suelo1.is_colliding() or protagonista.raycast_suelo2.is_colliding()) and protagonista.coyote_timer<=0:
		protagonista.falling_time +=delta
		if protagonista.falling_time>0.2:
			protagonista.falling_time=0
			state_machine.change_to("Fall")
			return
	
	handle_features(delta)
	handle_gravity(delta)
	protagonista.move_and_slide()

func on_input(event):
	if not Input.get_axis("Izquierda", "Derecha"):
		state_machine.change_to("Idle")
		return
	if Input.is_action_just_pressed("Saltar"):
		state_machine.change_to("Jump")
