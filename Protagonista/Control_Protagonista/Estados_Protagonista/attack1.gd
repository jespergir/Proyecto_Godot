class_name Attack1 extends PlayerStatesBaseState

func on_physics_process(delta: float) -> void:
	
	protagonista.animated_sprite.play("Attack1")
		
	var direction := Input.get_axis("Left", "Right")
	if direction:
		protagonista.velocity.x = protagonista.animated_sprite.scale.x * protagonista.SPEED
		protagonista.animated_sprite.scale.x = sign(direction)
		protagonista.attack1.scale.x = sign(direction)
	else:
		protagonista.velocity.x = move_toward(protagonista.velocity.x, 0, protagonista.SPEED)

	# Si la velocidad en y es 0 y está en el suelo, cambiar a Land
	if !protagonista.is_on_floor()  and (protagonista.raycast_suelo1.is_colliding() or protagonista.raycast_suelo2.is_colliding()):
		state_machine.change_to("Land")
		return
	
	handle_states(delta)
	protagonista.move_and_slide()

func damage():
	protagonista.damage_just_received = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if protagonista.animated_sprite.animation == "Attack1":
		state_machine.change_to("Idle")
	if protagonista.animated_sprite.animation == "Land":
		state_machine.change_to("Idle")
