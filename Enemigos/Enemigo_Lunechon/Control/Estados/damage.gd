class_name EnemigoLunechonDamage extends EnemigoLunechonBaseState

func start():
	enemigo.knockback_timer = enemigo.KNOCKBACK_TIME
	enemigo.animated_sprite1.modulate = Color(0.8,0,0,1)
	enemigo.animated_sprite2.modulate = Color(0.8,0,0,1)
	enemigo.velocity.x = enemigo.knockback_direction * (enemigo.SPEED/2)

func on_physics_process(delta: float) -> void:
	
	enemigo.knockback_timer -= delta
	
	if enemigo.knockback_timer <=0:
		enemigo.animated_sprite1.modulate = Color(1,1,1,1)
		enemigo.animated_sprite2.modulate = Color(1,1,1,1)
		enemigo.damage_just_received=false
		enemigo.hitted = true
		state_machine.change_to("Walk")
		return
	

	handle_states(delta)
	enemigo.move_and_slide()
