class_name Attack1 extends PlayerBaseState

var attack_animation_finished=false

func start():
	if not protagonista.audio_attack.playing:
		protagonista.audio_attack.play()

func on_physics_process(delta: float) -> void:
	
	protagonista.animated_sprite.play("Attack1")
	
#region MoveX
	var direction := Input.get_axis("Left", "Right")
	if direction:
		protagonista.velocity.x = protagonista.animated_sprite.scale.x * protagonista.SPEED
		protagonista.animated_sprite.scale.x = sign(direction)
		protagonista.attack1.scale.x = sign(direction)
	else:
		protagonista.velocity.x = move_toward(protagonista.velocity.x, 0, protagonista.SPEED)
#endregion
	
#region Jump
		# Si se pulsa la acción saltar, la almacena en búfer y si pasa poco rato hasta que se puede saltar, cambia a Saltar
		if protagonista.protagonista.jump_buffer_timer > 0 and protagonista.protagonista.coyote_timer > 0:
			state_machine.change_to("Jump")
			return
#endregion
	
#region Damage
	if protagonista.damage_just_received:
		state_machine.change_to("Damage")
		return
#endregion
	
#region Fall
	if attack_animation_finished:
		# Después de un segundo de caída (al caer mientras andas)
		if protagonista.velocity.y>=0 and (!protagonista.raycast_suelo1.is_colliding() or !protagonista.raycast_suelo2.is_colliding()) and protagonista.protagonista.coyote_time<=0:
			protagonista.falling_time +=delta
			if protagonista.falling_time>0.2:
				protagonista.falling_time=0
				state_machine.change_to("Fall")
				return
#endregion
	
#region Land
	if attack_animation_finished:
		# Si la velocidad en y es 0 y la protagonista está en el suelo, cambia a Land (al caer mientras andas)
		if protagonista.velocity.y > 0 and (protagonista.raycast_suelo1.is_colliding() or protagonista.raycast_suelo2.is_colliding()):
			state_machine.change_to("Land")
			return
#endregion
	
#region Death
	if protagonista.health <= 0:
		state_machine.change_to("Death")
		return
#endregion
	
	handle_states(delta)
	protagonista.move_and_slide()

func _on_animated_sprite_2d_frame_changed() -> void:
	var current_frame = protagonista.animated_sprite.frame
	var current_animation = protagonista.animated_sprite.animation
	if current_animation == "Attack1":
		
		if current_frame == 1 or current_frame == 2:
			protagonista.attack1_collision.disabled = false
		else:
			protagonista.attack1_collision.disabled = true
				
		if current_frame == 5:
			state_machine.change_to("Idle")
			return

func _on_animated_sprite_2d_animation_finished() -> void:
	if protagonista.animated_sprite.animation == "Attack1":
		attack_animation_finished=true
