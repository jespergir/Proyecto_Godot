class_name EnemigoRinoParametersBaseState extends EnemigoRanaBaseState

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")

func handle_states(delta):
	
	for i in enemigo.get_slide_collision_count():
		var collision = enemigo.get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("Protagonista"):
			collider.damage(enemigo.get_enemy_position())
	
	if !enemigo.is_on_floor():
		enemigo.velocity.y += gravity * delta


#func go_chase():
	#if enemigo.raycast_pared.is_colliding():
		#var pared = enemigo.raycast_pared.get_collider()
		#if pared.is_in_group("Protagonista"):
			#for ray in enemigo.vision_enemigo.get_children():
				#if ray.is_colliding() and enemigo.raycast_suelo.is_colliding():
					#var collider = ray.get_collider()
					#if collider.is_in_group("Protagonista"):
						#break
	#else:
		#for ray in enemigo.vision_enemigo.get_children():
				#if ray.is_colliding() and enemigo.raycast_suelo.is_colliding():
					#var collider = ray.get_collider()
					#if collider.is_in_group("Protagonista"):
						#state_machine.change_to("Chase")
						#break
