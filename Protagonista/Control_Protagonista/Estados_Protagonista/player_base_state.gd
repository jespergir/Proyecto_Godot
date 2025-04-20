class_name PlayerBaseState extends BaseState

var protagonista : Protagonista:
	set(value):
		controlled_node = value
	get:
		return controlled_node
