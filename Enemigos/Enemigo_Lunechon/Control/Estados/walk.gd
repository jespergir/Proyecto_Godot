class_name  EnemigoLunechonWalk extends EnemigoLunechonBaseState

func start():	
	enemigo.walking_time = enemigo.WALK_TIME
	enemigo.last_direction = enemigo.animated_sprite1.scale.x
	if not enemigo.hitted:
		enemigo.direction = enemigo.animated_sprite1.scale.x * -1
		enemigo.invert_scale()
	else:
		enemigo.direction = enemigo.animated_sprite1.scale.x
		enemigo.hitted=false
	
func on_physics_process(delta: float) -> void:
	
	enemigo.walking_time -= delta
	
#region Walk
	if enemigo.direction:
		enemigo.velocity.x = enemigo.direction * enemigo.SPEED
		if not enemigo.animated_sprite1.is_playing() or enemigo.animated_sprite1.animation != "Walk":
			enemigo.animated_sprite1.play("Run")
			enemigo.animated_sprite2.play("Run")
			
#endregion
	
#region Idle
	# Al detectar colisión con raycast_pared, invertir la dirección
	if enemigo.raycast_pared.is_colliding():
		var collider = enemigo.raycast_pared.get_collider()
		if !collider.is_in_group("Protagonista"):
			enemigo.direction = -enemigo.animated_sprite1.scale.x
			state_machine.change_to("Idle")
			return
	if enemigo.walking_time <= 0:
		state_machine.change_to("Idle")
		return
	if !enemigo.raycast_suelo.is_colliding():
			state_machine.change_to("Idle")
			return
#region Damage
	if enemigo.damage_just_received:
		state_machine.change_to("Damage")
		return
#endregion
	
	handle_states(delta)
	enemigo.move_and_slide()
