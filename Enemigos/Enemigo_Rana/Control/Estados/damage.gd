class_name EnemigoRanaDamage extends EnemigoRanaParametersBaseState

func on_physics_process(delta: float) -> void:
	
	enemigo.animated_sprite.play("Damage")
	enemigo.velocity.x = enemigo.knockback_direction * enemigo.SPEED/2

	handle_states(delta)
	enemigo.move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	if enemigo.animated_sprite.animation == "Damage":
		enemigo.damage_just_received=false
		state_machine.change_to("Idle")
