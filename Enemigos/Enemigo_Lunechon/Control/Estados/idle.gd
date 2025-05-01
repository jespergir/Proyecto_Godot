class_name EnemigoLunechonIdle extends EnemigoLunechonBaseState

func start(): #Al comienzo del estado Idle, empieza el contador
	enemigo.idling_time = enemigo.IDLE_TIME

func on_physics_process(delta: float) -> void:
	enemigo.velocity.x = move_toward(enemigo.velocity.x, 0, enemigo.SPEED) #Se asegura de que el enemigo esté quieto
	
#region Idle
	#Si no se está reproduciendo ninguna animación o la animación no es idle, reproduce idle.
	if not enemigo.animated_sprite1.is_playing() or enemigo.animated_sprite1.animation != "Idle":
		enemigo.animated_sprite1.play("Idle")
		enemigo.animated_sprite2.play("Idle")
	enemigo.idling_time-=delta #Se resta tiempo del contador Idle
#endregion
	
#region Walk
	if enemigo.idling_time <= 0: #Si se acaba el tiempo del contador, cambia al estado Walk
		state_machine.change_to("Walk")
		return
#endregion

#region Damage
	if enemigo.damage_just_received: #Si recibe daño, cambia al estado Damage
		state_machine.change_to("Damage")
		return
#endregion
	
	handle_states(delta) #Se encargan de la gravedad y los movimientos del enemigo
	enemigo.move_and_slide()
