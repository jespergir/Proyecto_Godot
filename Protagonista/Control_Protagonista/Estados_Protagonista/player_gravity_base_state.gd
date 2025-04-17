class_name PlayerFeaturesBaseState extends PlayerBaseState

var gravity : float  = ProjectSettings.get_setting("physics/2d/default_gravity")

func handle_gravity(delta):
	protagonista.velocity.y += gravity * delta

func handle_features(delta):
	if protagonista.is_on_floor() and protagonista.coyote_timer<=0: #Comprueba que está en el suelo.
		protagonista.coyote_timer = protagonista.COYOTE_TIME #Cuando está en el suelo el timer vale el tiempo total de coyote time.
	else:
		if protagonista.coyote_timer > 0: #Cuando el personaje está en el aire (si el coyote timer es mayor que 0).
			protagonista.coyote_timer -= delta
			
	if protagonista.jump_buffer_timer > 0:
		protagonista.jump_buffer_timer -=delta
