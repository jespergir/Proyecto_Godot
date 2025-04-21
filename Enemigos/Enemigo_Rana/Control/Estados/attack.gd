class_name EnemigoRanaAttack extends EnemigoRanaParametersBaseState

var body_exited = false
var attack = false

func start():
	enemigo.cast_attack_timer = enemigo.CAST_ATTACK_TIME
	attack = false

func on_physics_process(delta: float) -> void:
	
	enemigo.velocity.x = move_toward(enemigo.velocity.x, 0, enemigo.SPEED)
	enemigo.cast_attack_timer -= delta
	enemigo.animated_sprite.play("Attack")
	if attack :
		enemigo.velocity.x = enemigo.protagonista_direction * enemigo.SPEED * 2.5
		
		enemigo.attack_cooldown_time = enemigo.ATTACK_COOLDOWN
	handle_states(delta)
	enemigo.move_and_slide()

func _on_animated_sprite_2d_frame_changed() -> void:
	var current_frame = enemigo.animated_sprite.frame
	var current_animation = enemigo.animated_sprite.animation
	
	if current_animation == "Attack":
		if current_frame == 5:
			attack=true
		if current_frame == 5 or current_frame == 6:
			enemigo.attack_collision.disabled = false
			
		elif current_frame == 7:
			enemigo.attack_collision.disabled = true
#
func _on_animated_sprite_2d_animation_finished() -> void:
	if enemigo.animated_sprite.animation == "Attack":
		state_machine.change_to("Idle")


func _on_attack_collision_area_body_entered(body: Node2D) -> void:
		if  body.is_in_group("Protagonista"):
			body.damage(enemigo.global_position)


func _on_attack_collision_area_body_exited(body: Node2D) -> void:
	body_exited=true
