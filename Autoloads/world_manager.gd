extends Node

var rooms: Dictionary = {}

func load_room(room_name: String, position: Vector2):
	if rooms.has(room_name):
		return

	var scene = load(room_name)
	var room_instance = scene.instantiate()
	room_instance.position = position
	
	get_node("/root/World").call_deferred("add_child", room_instance)
	rooms[room_name] = room_instance
