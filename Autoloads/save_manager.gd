extends Node

var save_path := "user://save_data.save"
var protagonista : Protagonista

var data := {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if GameState.protagonista == null:
		GameState.connect("protagonista_ready", Callable(self, "_on_protagonista_ready"))
	else:
		_on_protagonista_ready()

func _on_protagonista_ready():
	protagonista = GameState.protagonista
	
#region Save game
# Función para guardar partida
func save_game(save_point_position):
	# Crea un archivo para escribir la información en él
	var file := FileAccess.open(save_path, FileAccess.WRITE)

	# Guarda los distintos datos en el diccionario data
	data["protagonista"] = {
		"position": [save_point_position.x, save_point_position.y],
		"health": protagonista.health,
		"coins": protagonista.coins
	}
	data["sala"] = {
		"nombre_sala": protagonista.nombre_sala_actual,
		"posicion_sala": [protagonista.posicion_sala_actual.x, protagonista.posicion_sala_actual.y]
	}
	data["minimapa"] = {
	"salas_visitadas": MinimapManager.salas_visitadas,
	"sala_actual": MinimapManager.sala_actual
	}

	print("💾 Guardando partida en sala:", protagonista.nombre_sala_actual,
	  " spawn:", save_point_position,
	  "   coins:", protagonista.coins)
	# Escribe los datos en el archivo y lo cierra
	file.store_string(JSON.stringify(data))
	file.close()

#endregion

#region Load game
# Función para cargar partida
func load_game():
	WorldManager.reset_world()

	# Si no existe el archivo lo avisa
	if not FileAccess.file_exists(save_path):
		print("No save file found.")
		return false

	# Recupera el archivo de guardado y lo convierte en string
	var file := FileAccess.open(save_path, FileAccess.READ)
	data = JSON.parse_string(file.get_as_text())
	file.close()
	if data.has("minimapa"):
		MinimapManager.salas_visitadas = data["minimapa"].get("salas_visitadas", {})
		MinimapManager.sala_actual = data["minimapa"].get("sala_actual", "")
	# Refresca el minimapa visual si está cargado
	if MinimapManager.minimap_node:
		MinimapManager.minimap_node.salas_visitadas = MinimapManager.salas_visitadas.duplicate()
		MinimapManager.minimap_node.sala_actual = MinimapManager.sala_actual
		MinimapManager.minimap_node.centrar_y_redibujar_minimapa()

	print("🔄 Cargando partida sala:", data["sala"]["nombre_sala"],
		" posición:", data["sala"]["posicion_sala"])

	# Prepara los datos necesarios
	var room_position_array = data["sala"]["posicion_sala"]
	var room_position = Vector2(room_position_array[0], room_position_array[1])
	var protagonista_data = data["protagonista"]

	# Carga la sala y pasa los datos de la protagonista
	WorldManager.load_room_by_position(data["sala"]["nombre_sala"], room_position, protagonista_data)

	return true
#endregion
