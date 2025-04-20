class_name EnemigoIdle extends EnemyStatesBaseState

func on_physics_process(delta: float) -> void:
	
	enemigo.velocity.x = move_toward(enemigo.velocity.x, 0, enemigo.SPEED)
	
#region Idle
	#Si no se está reproduciendo ninguna animación o la animación no es idle, reproduce idle.
	if not enemigo.animated_sprite.is_playing() or enemigo.animated_sprite.animation != "Idle":
		enemigo.animated_sprite.play("Idle")
		enemigo.idling_time = enemigo.IDLE_TIME
	
	enemigo.idling_time-=delta
#endregion
	
#region Walk
	if enemigo.idling_time <= 0:
		state_machine.change_to("Walk")
		return
#endregion
	
##region Attack
	#for ray in enemigo.vision_enemigo.get_children():
		#if ray.is_colliding() and enemigo.raycast_suelo.is_colliding():
			#var collider = ray.get_collider()
			#if collider.is_in_group("Protagonista"):
				#state_machine.change_to("Attack")
				#break
##endregion
	
##region Damage
	#if enemigo.damage_just_received:
		#state_machine.change_to("Damage")
		#return
##endregion
	
	#if enemigo.attack_cooldown_time <=0:
		#state_machine.change_to("Attack")
		#return
	

	


		
	handle_states(delta)
	enemigo.move_and_slide()

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Protagonista"):
		enemigo.can_attack=true


func _on_attack_range_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Protagonista"):
		enemigo.can_attack=false
