class_name Attack1 extends PlayerBaseState

func on_physics_process(delta: float) -> void:
	
	protagonista.animated_sprite.play("Attack1")
	
	var direction := Input.get_axis("Left", "Right")
	if direction:
		protagonista.velocity.x = protagonista.animated_sprite.scale.x * Protagonista.SPEED
		protagonista.animated_sprite.scale.x = sign(direction)
		protagonista.attack1.scale.x = sign(direction)
	else:
		protagonista.velocity.x = move_toward(protagonista.velocity.x, 0, protagonista.SPEED)

	# Si la velocidad en y es 0 y está en el suelo, cambiar a Land
	if !protagonista.is_on_floor()  and (protagonista.raycast_suelo1.is_colliding() or protagonista.raycast_suelo2.is_colliding()):
		state_machine.change_to("Land")
		return
	
	protagonista.move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	if protagonista.animated_sprite.animation == "Attack1":
		if not Input.get_axis("Left", "Right"):
			state_machine.change_to("Idle")
		else: 
			state_machine.change_to("Walk")
func _on_animated_sprite_2d_frame_changed() -> void:
	var current_frame = protagonista.animated_sprite.frame
	var current_animation = protagonista.animated_sprite.animation

	if current_animation == "Attack1" and current_frame == 1:
		protagonista.attack1_first_collision.disabled = false
	elif current_animation == "Attack1" and current_frame == 2:
		protagonista.attack1_first_collision.disabled = true
		protagonista.attack1_second_collision.disabled = false
	elif current_animation == "Attack1a" and current_frame > 2:
		protagonista.attack1_second_collision.disabled = true
