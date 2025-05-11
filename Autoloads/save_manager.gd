extends Node

var save_path := "user://save_data.save"
var protagonista : Protagonista

var data := {}

#region Save game
# Función para guardar partida
func save_game():
	# Crea un archivo para escribir la información en él
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	
	# Guarda los distintos datos en el diccionario data
	data["protagonista"] = {
		"position": [protagonista.global_position.x, protagonista.global_position.y],
		"health": protagonista.health,
	}
	data["sala"] = {
		"nombre_sala": protagonista.nombre_sala_actual,
		"posicion_sala": [protagonista.posicion_sala_actual.x, protagonista.posicion_sala_actual.y]
	}
	
	# Escribe los datos en el archivo y lo cierra
	file.store_string(JSON.stringify(data))
	file.close()
#endregion

#region Load game
# Función para cargar partida
func load_game():
	#Si no existe el archivo lo avisa
	if not FileAccess.file_exists(save_path):
		print("No save file found.")
		return false
	
	# Recupera el archivo de cuardado y lo convierte en string
	var file := FileAccess.open(save_path, FileAccess.READ)
	data = JSON.parse_string(file.get_as_text())
	file.close()
	
	# Recupera la posición de la sala y la instancia
	var room_position_array = data["sala"]["posicion_sala"]
	var room_position = Vector2(room_position_array[0], room_position_array[1])
	WorldManager.load_room_from_save(data["sala"]["nombre_sala"], room_position)
	return true
#endregion

#region Position main character
func posicionar_protagonista():
	# Recuperar posición de la protagonista del archivo de guardado
	var position_array = data["protagonista"]["position"]
	
	# Posicionar a la protagonista
	protagonista.global_position = Vector2(position_array[0], position_array[1])
	protagonista.health = data["protagonista"]["health"]
	
#endregion
