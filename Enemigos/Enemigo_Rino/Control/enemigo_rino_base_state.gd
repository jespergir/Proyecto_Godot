class_name EnemigoRinoBaseState extends BaseState

var enemigo : EnemigoRino:
	set(value):
		controlled_node = value
	get:
		return controlled_node
