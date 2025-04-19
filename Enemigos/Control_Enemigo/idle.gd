#
#func start():	
	#if not enemigo.animated_sprite.is_playing() or enemigo.animated_sprite.animation != "Idle":
		#enemigo.animated_sprite.play("Idle")
		#enemigo.idling_time = enemigo.IDLE_TIME
#
#func on_physics_process(delta: float) -> void:
	#
	#enemigo.idling_time-=delta
	## La velocidad de la protagonista en x es 0
	#enemigo.velocity.x = move_toward(enemigo.velocity.x, 0, enemigo.SPEED)
	#
	#if enemigo.raycast_vision.is_colliding() and !enemigo.can_attack:
		#var body = enemigo.raycast_vision.get_collider()
		#if body.is_in_group("Protagonista"):
			#state_machine.change_to("Chase")
	#if enemigo.can_attack and enemigo.attack_range_area.get_overlapping_bodies().has(enemigo.protagonista):
		#state_machine.change_to("Attack")
#
	#if enemigo.idling_time <= 0:
		#state_machine.change_to("Walk")
	### Si se pulsa la acción saltar, la almacena en búfer y si pasa poco rato hasta que se puede saltar, cambia a Saltar
	##if Input.is_action_just_pressed("Attack1"):
		##state_machine.change_to("Attack1")
		##return
#
	#enemigo.move_and_slide()
#
#func _on_attack_range_body_entered(body: Node2D) -> void:
	#if body.is_in_group("Protagonista"):
		#enemigo.can_attack=true
#
#
#func _on_attack_range_area_body_exited(body: Node2D) -> void:
	#if body.is_in_group("Protagonista"):
		#enemigo.can_attack=false
