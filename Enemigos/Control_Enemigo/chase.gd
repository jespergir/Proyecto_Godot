class_name Enemy_Chase extends EnemyBaseState

func start():	
	enemigo.chasing_time = enemigo.CHASE_TIME

var body

func on_physics_process(delta: float) -> void:
	
	var direction = (enemigo.protagonista.position - enemigo.global_position).normalized()
	enemigo.velocity.x = (direction.x * enemigo.SPEED*1.5)
	
	enemigo.animated_sprite.play("Run")	
	
	if enemigo.is_on_wall():
		state_machine.change_to("Idle")
		
	if enemigo.raycast_vision.is_colliding():
		var body = enemigo.raycast_vision.get_collider()
		if body.is_in_group("Protagonista") and enemigo.can_attack:
			state_machine.change_to("Attack")
		else:
			enemigo.chasing_time-=delta
			
	if  enemigo.chasing_time <=0:
		state_machine.change_to("Idle")
				
	#if enemigo.raycast_vision.is_colliding() and enemigo.can_attack:
		#var body = enemigo.raycast_vision.get_collider()
		#if body.is_in_group("Protagonista"):
			#state_machine.change_to("Attack")
			#return
	#
	#if enemigo.raycast_vision.is_colliding():
		#body = enemigo.raycast_vision.get_collider()
		#if enemigo.can_attack:
			#state_machine.change_to("Attack")
			#return
		#if !body.is_in_group("Protagonista"):
			#enemigo.chasing_time-=delta
			#if  enemigo.chasing_time <=0:
				#state_machine.change_to("Idle")
	#else:
		#enemigo.chasing_time-=delta
		#if  enemigo.chasing_time <=0:
			#state_machine.change_to("Idle")


	
	enemigo.move_and_slide()

func _on_attack_range_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Protagonista"):
		enemigo.can_attack=true

func _on_attack_range_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Protagonista"):
		enemigo.can_attack=false
