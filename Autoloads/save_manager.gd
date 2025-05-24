extends Node

# Ruta donde se guarda el archivo
var save_path := "user://save_data.save"

# Referencia a la protagonista
var protagonista : Protagonista

# Diccionario para almacenar los datos a guardar
var data := {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS #Hace que este nodo no sea pausable

	#region Protagonista Ready
	# Espera a que GameState tenga la referencia de la protagonista
	if GameState.protagonista == null:
		GameState.connect("protagonista_ready", Callable(self, "_on_protagonista_ready"))
	else:
		_on_protagonista_ready()
	#endregion

func _on_protagonista_ready():
	protagonista = GameState.protagonista #Guarda la referencia a la protagonista

#region Save game
# Función para guardar partida
func save_game(save_point_position):
	var file := FileAccess.open(save_path, FileAccess.WRITE) #Crea archivo en modo escritura

	# Guarda los datos de la protagonista
	data["protagonista"] = {
		"position": [save_point_position.x, save_point_position.y],
		"health": protagonista.health,
		"coins": protagonista.coins
	}

	# Guarda el nombre y la posición de la sala
	data["sala"] = {
		"nombre_sala": protagonista.nombre_sala_actual,
		"posicion_sala": [protagonista.posicion_sala_actual.x, protagonista.posicion_sala_actual.y]
	}

	# Guarda la información del minimapa
	data["minimapa"] = {
		"salas_visitadas": MinimapManager.salas_visitadas,
		"sala_actual": MinimapManager.sala_actual
	}

	print("💾 Guardando partida en sala:", protagonista.nombre_sala_actual,
	  " spawn:", save_point_position,
	  "   coins:", protagonista.coins)

	# Convierte el diccionario a JSON y lo guarda en el archivo
	file.store_string(JSON.stringify(data))
	file.close()
#endregion

#region Load game
# Función para cargar partida
func load_game():
	WorldManager.reset_world() #Resetea el mundo antes de cargar

	if not FileAccess.file_exists(save_path): #Si no existe el archivo, avisa y cancela
		print("No save file found.")
		return false

	# Lee el archivo de guardado
	var file := FileAccess.open(save_path, FileAccess.READ)
	data = JSON.parse_string(file.get_as_text())
	file.close()

	# Recupera datos del minimapa y actualiza su estado
	if data.has("minimapa"):
		MinimapManager.salas_visitadas = data["minimapa"].get("salas_visitadas", {})
		MinimapManager.sala_actual = data["minimapa"].get("sala_actual", "")
	if MinimapManager.minimap_node:
		MinimapManager.minimap_node.salas_visitadas = MinimapManager.salas_visitadas.duplicate()
		MinimapManager.minimap_node.sala_actual = MinimapManager.sala_actual
		MinimapManager.minimap_node.centrar_y_redibujar_minimapa()

	print("🔄 Cargando partida sala:", data["sala"]["nombre_sala"],
		" posición:", data["sala"]["posicion_sala"])

	# Extrae los datos necesarios para cargar la sala y la protagonista
	var room_position_array = data["sala"]["posicion_sala"]
	var room_position = Vector2(room_position_array[0], room_position_array[1])
	var protagonista_data = data["protagonista"]

	# Carga la sala e inicializa la protagonista con los datos guardados
	WorldManager.load_room_by_position(data["sala"]["nombre_sala"], room_position, protagonista_data)

	return true
#endregion
