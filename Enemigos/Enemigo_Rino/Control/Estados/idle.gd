class_name EnemigoRinoIdle extends EnemigoRinoParametersBaseState

func start():
	enemigo.idling_time = enemigo.IDLE_TIME

func on_physics_process(delta: float) -> void:
	
	enemigo.velocity.x = move_toward(enemigo.velocity.x, 0, enemigo.SPEED)
	
#region Idle
	#Si no se está reproduciendo ninguna animación o la animación no es idle, reproduce idle.
	if not enemigo.animated_sprite.is_playing() or enemigo.animated_sprite.animation != "Idle":
		enemigo.animated_sprite.play("Idle")
	enemigo.idling_time-=delta
#endregion
	
#region Walk
	if enemigo.idling_time <= 0:
		state_machine.change_to("Walk")
		return
#endregion

#region Damage
	if enemigo.damage_just_received:
		state_machine.change_to("Damage")
		return
#endregion
	
	handle_states(delta)
	enemigo.move_and_slide()
