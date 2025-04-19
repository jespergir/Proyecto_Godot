class_name EnemyAttack extends EnemyBaseState

var body_exited = false

func on_physics_process(delta: float) -> void:
	
	if enemigo.attack_cooldown_time <= 0:
		enemigo.animated_sprite.play("Attack")
		enemigo.attack_cooldown_time = enemigo.ATTACK_COOLDOWN


	enemigo.move_and_slide()

func _on_animated_sprite_2d_frame_changed() -> void:
	var current_frame = enemigo.animated_sprite.frame
	var current_animation = enemigo.animated_sprite.animation
	
	if enemigo.attack_cooldown_time <= 0:
		if current_animation == "Attack" and current_frame == 2:
			enemigo.attack_collision.disabled=false
		elif current_animation == "Attack" and current_frame == 4:
			enemigo.attack_collision.disabled = true

func _on_attack_collision_body_entered(body: Node2D) -> void:
	if enemigo.attack_cooldown_time <= 0:
		if  body.is_in_group("Protagonista"):
			body.damage()


func _on_animated_sprite_2d_animation_finished() -> void:
	state_machine.change_to("Idle")
