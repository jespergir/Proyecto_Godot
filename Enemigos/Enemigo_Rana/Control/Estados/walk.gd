class_name EnemigoRanaWalk extends EnemigoRanaParametersBaseState

func start():	
	enemigo.walking_time = enemigo.WALK_TIME
	enemigo.last_direction = enemigo.animated_sprite.scale.x
	enemigo.direction = enemigo.animated_sprite.scale.x * -1
	enemigo.invert_scale()
	
func on_physics_process(delta: float) -> void:

	enemigo.walking_time -= delta
	
#region Walk
	if enemigo.direction:
		enemigo.velocity.x = enemigo.direction * enemigo.SPEED
		if not enemigo.animated_sprite.is_playing() or enemigo.animated_sprite.animation != "Walk":
			enemigo.animated_sprite.play("Walk")
#endregion

#region Idle
	# Al detectar colisión con raycast_pared, invertir la dirección
	if enemigo.raycast_pared.is_colliding():
		var collider = enemigo.raycast_pared.get_collider()
		if !collider.is_in_group("Protagonista"):
			enemigo.direction = -enemigo.animated_sprite.scale.x
			state_machine.change_to("Idle")
			return
	if enemigo.walking_time <= 0:
		state_machine.change_to("Idle")
		return
	if !enemigo.raycast_suelo.is_colliding() or enemigo.raycast_pared.is_colliding():
		var collider = enemigo.raycast_pared.get_collider()
		if !collider.is_in_group("Protagonista"):
			state_machine.change_to("Idle")
			return
#endregion

	for i in enemigo.get_slide_collision_count():
		var collision = enemigo.get_slide_collision(i)
		var collider = collision.get_collider()
		var protagonista : Protagonista = collider as Protagonista
		if collider.is_in_group("Protagonista"):
			collider.damage(enemigo.global_position)



#region Attack
	for ray in enemigo.vision_enemigo.get_children():
		if ray.is_colliding() and enemigo.raycast_suelo.is_colliding():
			var collider = ray.get_collider()
			if collider.is_in_group("Protagonista"):
				enemigo.protagonista_direction = sign(collider.global_position.x - enemigo.global_position.x)
				state_machine.change_to("Attack")
				break
#endregion
	
##region Attack
	#if enemigo.attack_cooldown_time<=0:
		#state_machine.change_to("Attack")
		#return
##endregion
	
#region Damage
	if enemigo.damage_just_received:
		state_machine.change_to("Damage")
		return
#endregion
	
	handle_states(delta)
	enemigo.move_and_slide()
	

			#collider.hit()
#
		#if enemy:
			#print("collider as Enemy")
			#enemy.hit()

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Protagonista"):
		enemigo.can_attack=true


func _on_attack_range_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Protagonista"):
		enemigo.can_attack=false


func _on_attack_range_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
