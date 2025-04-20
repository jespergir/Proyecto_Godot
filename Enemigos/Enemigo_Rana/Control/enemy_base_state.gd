class_name EnemyBaseState extends BaseState

var enemigo : Enemigo:
	set(value):
		controlled_node = value
	get:
		return controlled_node
