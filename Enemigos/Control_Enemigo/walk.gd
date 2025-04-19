#
#func start():	
	#walking_time = WALK_TIME
	#last_direction = animated_sprite.scale.x
	#invertir_escala()
#
#func on_physics_process(delta: float) -> void:
	#
	#walking_time -=delta
	#
	#var direction = last_direction * -1
#
	#if direction:
		#velocity.x = direction * SPEED
		#animated_sprite.play("Walk")
#
	#if is_on_wall():
		#state_machine.change_to("Idle")
	#
	#if raycast_vision.is_colliding():
		#var body = raycast_vision.get_collider()
		#if body.is_in_group("Protagonista") and !can_attack:
			#state_machine.change_to("Chase")
		#elif body.is_in_group("Protagonista") and can_attack:
			#state_machine.change_to("Attack")
		#
	#if walking_time <= 0:
		#state_machine.change_to("Idle")
		#return
	#
	#move_and_slide()
#
#func _on_attack_range_body_entered(body: Node2D) -> void:
	#if body.is_in_group("Protagonista"):
		#can_attack=true
#
#
#func _on_attack_range_area_body_exited(body: Node2D) -> void:
	#if body.is_in_group("Protagonista"):
		#can_attack=false
