#var body_exited = false
#
#func on_physics_process(delta: float) -> void:
	#
	#if attack_cooldown_time <= 0:
		#animated_sprite.play("Attack")
		#attack_cooldown_time = ATTACK_COOLDOWN
#
#
	#move_and_slide()
#
#func _on_animated_sprite_2d_frame_changed() -> void:
	#var current_frame = animated_sprite.frame
	#var current_animation = animated_sprite.animation
	#
	#if attack_cooldown_time <= 0:
		#if current_animation == "Attack" and current_frame == 2:
			#attack_collision.disabled=false
		#elif current_animation == "Attack" and current_frame == 4:
			#attack_collision.disabled = true
#
#func _on_attack_collision_body_entered(body: Node2D) -> void:
	#if attack_cooldown_time <= 0:
		#if  body.is_in_group("Protagonista"):
			#body.damage()
#
#
#func _on_animated_sprite_2d_animation_finished() -> void:
	#state_machine.change_to("Idle")
