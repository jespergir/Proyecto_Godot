class_name EnemyStatesBaseState extends EnemyBaseState

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")

func handle_states(delta):
	
	if !enemigo.is_on_floor():
		enemigo.velocity.y += gravity * delta
	enemigo.attack_cooldown_time -= delta
	enemigo.chasing_time -= delta


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
