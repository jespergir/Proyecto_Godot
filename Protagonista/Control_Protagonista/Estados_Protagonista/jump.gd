class_name Jump extends PlayerStatesBaseState
var jump_released :=false

func on_physics_process(delta: float) -> void:

	if protagonista.jump_buffer_timer > 0 and protagonista.coyote_timer > 0:
		protagonista.velocity.y = protagonista.JUMP_VELOCITY
		protagonista.animated_sprite.play("Jump")
		protagonista.falling_time=0
		protagonista.jump_buffer_timer = 0
		protagonista.coyote_timer = 0
		
	# Salto variable: si soltó el salto, cortar el salto
	if Input.is_action_just_released("Jump") and protagonista.velocity.y < 0:
		protagonista.velocity.y *= protagonista.JUMP_CUT_MULTIPLIER
		
	# Controlar la dirección mientras salta
	var direction := Input.get_axis("Left", "Right")
	if direction:
		protagonista.velocity.x = direction * Protagonista.SPEED
		protagonista.animated_sprite.scale.x = sign(direction)
	else:
		protagonista.velocity.x = move_toward(protagonista.velocity.x, 0, protagonista.SPEED)
		
	if  Input.is_action_just_pressed("Attack1"):
		state_machine.change_to("Attack1")
		return
		
	# Después de un segundo de caída, cambiar a Fall
	if protagonista.velocity.y>=0 and !(protagonista.raycast_suelo1.is_colliding() or protagonista.raycast_suelo2.is_colliding()) and protagonista.coyote_timer<=0:
		protagonista.falling_time +=delta
		if protagonista.falling_time>1:
			protagonista.falling_time=0
			state_machine.change_to("Fall")
			return
	
	# Si la velocidad en y es 0 y está en el suelo, cambiar a Land
	if protagonista.velocity.y > 0 and (protagonista.raycast_suelo1.is_colliding() or protagonista.raycast_suelo2.is_colliding()):
		state_machine.change_to("Land")
		return
	
	handle_states(delta)
	protagonista.move_and_slide()


#
#
#func _on_animated_sprite_2d_animation_finished() -> void:
	#if protagonista.animated_sprite.animation == "jump":
		#if protagonista.is_on_floor():
			#state_machine.change_to("Land")
