class_name EnemigoLunechonDamage extends EnemigoLunechonBaseState

var deathstarted = false
var deathfinished = false

func start():
	enemigo.knockback_timer = enemigo.KNOCKBACK_TIME
	enemigo.animated_sprite1.modulate = Color(0.8,0,0,1)
	enemigo.animated_sprite2.modulate = Color(0.8,0,0,1)
	enemigo.velocity.x = enemigo.knockback_direction * (enemigo.SPEED/2)

func on_physics_process(delta: float) -> void:
	
	enemigo.knockback_timer -= delta
	
	if enemigo.health <=0 and not deathstarted:
		deathstarted = true
		enemigo.animated_sprite1.play("Idle")
		enemigo.animated_sprite2.play("Idle")
		enemigo.animation_player.play("Death")
		
	if enemigo.knockback_timer <=0:
		enemigo.animated_sprite1.modulate = Color(1,1,1,1)
		enemigo.animated_sprite2.modulate = Color(1,1,1,1)
		enemigo.damage_just_received=false
		enemigo.hitted = true
		if enemigo.health!=0:
			state_machine.change_to("Walk")
			return
	

	handle_states(delta)
	enemigo.move_and_slide()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	enemigo.velocity.x = move_toward(enemigo.velocity.x, 0, enemigo.SPEED)
	if anim_name == "Death":
		enemigo.animation_player.pause()
		var spawn_position = enemigo.global_position

		var cristal = enemigo.cristal.instantiate()
		cristal.global_position = enemigo.global_position
		get_tree().current_scene.add_child(cristal) # MUY importante: añadirlo directo
		enemigo.animated_sprite1.rotation = 0
		enemigo.animated_sprite1.play("Explosion")
		return



func _on_animated_sprite_up_animation_finished() -> void:
	enemigo.velocity.x = move_toward(enemigo.velocity.x, 0, enemigo.SPEED)

	if enemigo.animated_sprite1.animation == "Explosion":
		enemigo.call_deferred("queue_free")
