class_name  EnemigoRanaChase extends EnemigoRanaParametersBaseState

func start():	
	enemigo.chasing_time = enemigo.CHASE_TIME

func on_physics_process(delta: float) -> void:
	# Si todavía puede ver a la protagonista, actualiza la dirección
	if enemigo.is_protagonista_visible():
		enemigo.direction = (enemigo.protagonista.position - enemigo.global_position).normalized()
	
	if enemigo.chasing_time > 0:
		enemigo.velocity.x = enemigo.direction.x * enemigo.SPEED * 1.5
		enemigo.animated_sprite.play("Run")
	
	#if enemigo.chasing_time > 0 and enemigo.attack_cooldown_time <=0:
			#state_machine.change_to("Attack")
	#else:
		#if enemigo.chasing_time > 0:
			
	## Mientras esté en tiempo de persecución, sigue corriendo en la última dirección válida
	#if enemigo.is_on_wall():
		#state_machine.change_to("Idle")

	for ray in enemigo.vision_enemigo.get_children():
		if ray.is_colliding():
			var collider = ray.get_collider()
			if !collider.is_in_group("Protagonista") and enemigo.chasing_time<=0:
				state_machine.change_to("Idle")
				break
		else:
			if enemigo.chasing_time<=0:
				state_machine.change_to("Idle")
				break
	
	handle_states(delta)
	enemigo.move_and_slide()
