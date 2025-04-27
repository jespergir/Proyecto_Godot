class_name EnemigoLunechonBaseState extends BaseState

var enemigo : EnemigoRino:
	set(value):
		controlled_node = value
	get:
		return controlled_node

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")

func handle_states(delta):

	if !enemigo.is_on_floor():
		enemigo.velocity.y += gravity * delta
