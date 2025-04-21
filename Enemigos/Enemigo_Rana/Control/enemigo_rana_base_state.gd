class_name EnemigoRanaBaseState extends BaseState

var enemigo : EnemigoRana:
	set(value):
		controlled_node = value
	get:
		return controlled_node
