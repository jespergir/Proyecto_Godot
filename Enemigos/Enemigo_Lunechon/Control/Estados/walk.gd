class_name  EnemigoLunechonWalk extends EnemigoLunechonBaseState

func start(): #Inicia el contador walking_time y hace que el enemigo se gire en la dirección opuesta a donde estaba mirando.
	enemigo.walking_time = enemigo.WALK_TIME
	enemigo.last_direction = enemigo.animations.scale.x
	if not enemigo.hitted:
		enemigo.direction = enemigo.animations.scale.x * -1
		invert_scale()
	else:
		enemigo.direction = enemigo.animations.scale.x
		enemigo.hitted=false
	
func on_physics_process(delta: float) -> void:
	enemigo.walking_time -= delta #Resta tiempo del contador
	
#region Walk
	if enemigo.direction: #Si hay dirección, mueve el anemeigo
		enemigo.velocity.x = enemigo.direction * enemigo.SPEED
		if not enemigo.animated_sprite1.is_playing() or enemigo.animated_sprite1.animation != "Run":
			enemigo.animated_sprite1.play("Run")
			enemigo.animated_sprite2.play("Run")
#endregion
	
#region Idle
	# Al detectar colisión con raycast_pared, cambia al estado Idle
	if enemigo.raycast_pared.is_colliding():
		var collider = enemigo.raycast_pared.get_collider()
		if !collider.is_in_group("Protagonista"):
			enemigo.direction = -enemigo.animations.scale.x
			state_machine.change_to("Idle")
			return
	if enemigo.walking_time <= 0: #Si se acaba el walking_time, cambia al estado Idle
		state_machine.change_to("Idle")
		return
	if !enemigo.raycast_suelo.is_colliding(): #Si no hay suelo delante, cambia al estado Idle
			state_machine.change_to("Idle")
			return
	
#region Damage
	if enemigo.damage_just_received: #Si recibe daño, cambia al estado Idle
		state_machine.change_to("Damage")
		return
#endregion
	
	handle_states(delta)
	enemigo.move_and_slide()
