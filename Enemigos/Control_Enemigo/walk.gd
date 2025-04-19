class_name Enemy_Walk extends EnemyBaseState

func start():	
	enemigo.walking_time = enemigo.WALK_TIME
	enemigo.last_direction = enemigo.animated_sprite.scale.x
	enemigo.invertir_escala()

func on_physics_process(delta: float) -> void:
	
	enemigo.walking_time -=delta
	
	var direction = enemigo.last_direction * -1

	if direction:
		enemigo.velocity.x = direction * enemigo.SPEED
		enemigo.animated_sprite.play("Walk")

	if enemigo.is_on_wall():
		state_machine.change_to("Idle")
	
	if enemigo.raycast_vision.is_colliding():
		var body = enemigo.raycast_vision.get_collider()
		if body.is_in_group("Protagonista") and !enemigo.can_attack:
			state_machine.change_to("Chase")
		elif body.is_in_group("Protagonista") and enemigo.can_attack:
			state_machine.change_to("Attack")
		
	if enemigo.walking_time <= 0:
		state_machine.change_to("Idle")
		return
	
	enemigo.move_and_slide()

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Protagonista"):
		enemigo.can_attack=true


func _on_attack_range_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Protagonista"):
		enemigo.can_attack=false
