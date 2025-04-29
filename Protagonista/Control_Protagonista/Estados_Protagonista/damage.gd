class_name Damage extends PlayerBaseState

var damage_animation_finished = false

func start():	
	protagonista.animated_sprite.play("Damage")
	protagonista.knockback_timer = protagonista.KNOCKBACK_TIME
#region Modulate
	protagonista.animated_sprite.modulate = Color(0.8,0,0,1)
#endregion
	protagonista.damage_just_received = false
	protagonista.velocity.x = protagonista.knockback_direction * (protagonista.SPEED)
	protagonista.velocity.y = protagonista.SPEED * -1

func on_physics_process(delta: float) -> void:
	if protagonista.knockback_timer <=0 and damage_animation_finished:
	#region Modulate
		protagonista.animated_sprite.modulate = Color(1,1,1,1)
	#endregion
	#region Walk
		# Si se pulsa Izquierda o Derecha, cambia a walk
		var direction := Input.get_axis("Left", "Right")
		if direction:
			state_machine.change_to("Walk")
			return
		else:
			state_machine.change_to("Idle")
	#endregion
		
	#region Jump
		if protagonista.protagonista.jump_buffer_timer > 0 and protagonista.protagonista.coyote_timer > 0:
			state_machine.change_to("Jump")
			return	
	#endregion
		
	#region Fall
		# Después de un segundo de caída (al caer mientras andas)
		if protagonista.velocity.y>=0 and (!protagonista.raycast_suelo1.is_colliding() or !protagonista.raycast_suelo2.is_colliding()) and protagonista.protagonista.coyote_timer<=0:
			protagonista.falling_time +=delta
			if protagonista.falling_time>0.2:
				protagonista.falling_time=0
				state_machine.change_to("Fall")
				return
	#endregion
		
	#region Land
		# Si la velocidad en y es 0 y la protagonista está en el suelo, cambia a Land (al caer mientras andas)
		if protagonista.velocity.y > 0 and (protagonista.raycast_suelo1.is_colliding() or protagonista.raycast_suelo2.is_colliding()):
			state_machine.change_to("Land")
			return
	#endregion
		
	#region Attack1
		if  Input.is_action_just_pressed("Attack1"):
			state_machine.change_to("Attack1")
			return
	#endregion
	
	handle_states(delta)
	protagonista.move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	if protagonista.animated_sprite.animation == "Damage":
		damage_animation_finished=true
