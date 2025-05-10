extends Node

var save_path := "user://save_data.save"
var protagonista : Protagonista

var data := {}

func save_game():
	
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	
	data["protagonista"] = {
		"position": [protagonista.global_position.x, protagonista.global_position.y],
		"health": protagonista.health,
		"nombre_sala": protagonista.nombre_sala_actual,
		"posicion_sala": [protagonista.posicion_sala_actual.x, protagonista.posicion_sala_actual.y]
	}
	
	file.store_string(JSON.stringify(data))
	file.close()

func load_game():
	if not FileAccess.file_exists(save_path):
		print("No save file found.")
		return false
	var file := FileAccess.open(save_path, FileAccess.READ)
	data = JSON.parse_string(file.get_as_text())
	file.close()
	
	var position_sala_array = data["protagonista"]["posicion_sala"]
	var posicion_sala = Vector2(position_sala_array[0], position_sala_array[1])
	WorldManager.load_room_from_save(data["protagonista"]["nombre_sala"], posicion_sala)
	return true

func posicionar_protagonista():
		# Restaurar datos
	var position_array = data["protagonista"]["position"]
	protagonista.global_position = Vector2(position_array[0], position_array[1])
	protagonista.health = data["protagonista"]["health"]
