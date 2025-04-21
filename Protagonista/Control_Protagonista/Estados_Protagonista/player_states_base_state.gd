class_name PlayerStatesBaseState extends PlayerBaseState

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")

func handle_states(delta):
	
	if protagonista.is_on_floor() and protagonista.coyote_timer<=0: #Comprueba que está en el suelo.
		protagonista.coyote_timer = protagonista.COYOTE_TIME #Cuando está en el suelo el timer vale el tiempo total de coyote time.
	else:
		protagonista.velocity.y += gravity * delta
		if protagonista.coyote_timer > 0: #Cuando el personaje está en el aire (si el coyote timer es mayor que 0).
			protagonista.coyote_timer -= delta

	if Input.is_action_just_pressed("Jump"):
		protagonista.jump_buffer_timer = protagonista.JUMP_BUFFER_TIME
		
	for i in protagonista.get_slide_collision_count():
		var collision = protagonista.get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("Enemigo"):
			protagonista.damage(collider.get_enemy_position())
		
	if protagonista.jump_buffer_timer > 0:
		protagonista.jump_buffer_timer -=delta
