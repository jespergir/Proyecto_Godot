extends Node

# Diccionario que almacena las salas cargadas
var rooms: Dictionary = {}

# Referencias a la protagonista y al mundo
var protagonista : Protagonista
var world

# Enum para identificar la dirección en la que cargar una nueva sala
enum posiciones {Derecha, Izquierda, Arriba, Abajo}

# Temporizador para controlar cuándo descargar salas
var temporizador = 0.0
var carga = false

# Flags para controlar el estado del juego
var jugando = false
var new_game = false

# Señal que se emite al cargar una partida
signal partida_cargada

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS #Hace que esta escena no sea pausable

	# Espera a que GameState tenga referencias necesarias
	if GameState.protagonista == null:
		GameState.connect("protagonista_ready", Callable(self, "_on_protagonista_ready"))
	else:
		_on_protagonista_ready()
	if GameState.world == null:
		GameState.connect("world_ready", Callable(self, "_on_world_ready"))
	else:
		_on_world_ready()

func _on_protagonista_ready():
	protagonista = GameState.protagonista
	if new_game:
		protagonista.iniciar_variables() #Si es nueva partida, inicializa la protagonista

func _on_world_ready():
	world = GameState.world

func _process(delta): #Cada 2 segundos llama a unload_distant_rooms para descargar salas lejanas de la memoria.
	if jugando:
		temporizador += delta
		if temporizador > 2.0:
			temporizador = 0
			unload_distant_rooms()

#region Unload rooms while playing
#Función para liberar salas lejanas de la memoria
func unload_distant_rooms():
	if not is_instance_valid(protagonista):
		return

	var posicion_protagonista = protagonista.global_position #Posición actual de la protagonista

	for room_name in rooms.keys(): #Recorre todas las salas cargadas
		var room = rooms[room_name]
		if not is_instance_valid(room): #Si ya no existe la sala, la salta
			continue

		var distance = posicion_protagonista.distance_to(room.global_position) #Calcula la distancia a la protagonista

		if distance > 5000: #Si la sala está demasiado lejos, se elimina
			room.queue_free()
			rooms.erase(room_name)
#endregion

#region Load room while playing
#Función para cargar salas en tiempo de ejecución
func load_room(room_name: String, position_sala_actual: Vector2, ancho_sala_actual, alto_sala_actual, posicion_sala_siguiente):
	if rooms.has(room_name): #Si ya está cargada, no hace nada
		return

	# Solicita la carga en segundo plano
	ResourceLoader.load_threaded_request(room_name)

	# Espera a que finalice la carga
	while ResourceLoader.load_threaded_get_status(room_name) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await Engine.get_main_loop().process_frame

	# Verifica que se haya cargado bien
	if ResourceLoader.load_threaded_get_status(room_name) != ResourceLoader.THREAD_LOAD_LOADED:
		printerr("Error al cargar la sala: ", room_name)
		return

	var scene := ResourceLoader.load_threaded_get(room_name)
	var room_instance : Sala = scene.instantiate()

	room_instance.position = Vector2(99999, 99999) #Posición inicial fuera de la vista
	get_node("/root/World").call_deferred("add_child", room_instance)
	await room_instance.ready #Espera a que esté lista

	var ancho_sala_siguiente = room_instance.ancho
	var alto_sala_siguiente = room_instance.alto

#region Match dirección de la siguiente sala
	#Posiciona la nueva sala en función de la dirección
	match posicion_sala_siguiente:
		posiciones.Derecha:
			room_instance.position = position_sala_actual + Vector2(ancho_sala_actual, 0)
		posiciones.Izquierda:
			room_instance.position = position_sala_actual - Vector2(ancho_sala_siguiente, 0)
		posiciones.Arriba:
			room_instance.position = position_sala_actual + Vector2(0, alto_sala_siguiente)
		posiciones.Abajo:
			room_instance.position = position_sala_actual - Vector2(0, alto_sala_actual)
#endregion

	rooms[room_name] = room_instance #Guarda la sala en el diccionario
#endregion

#region Load room from save archive
#Carga una sala específica desde un archivo de guardado
func load_room_by_position(room_name: String, position_sala: Vector2, protagonista_data := {}):
	if rooms.has(room_name):
		return

	ResourceLoader.load_threaded_request(room_name)

	while ResourceLoader.load_threaded_get_status(room_name) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await Engine.get_main_loop().process_frame

	if ResourceLoader.load_threaded_get_status(room_name) != ResourceLoader.THREAD_LOAD_LOADED:
		printerr("Error al cargar la sala: ", room_name)
		return

	var scene := ResourceLoader.load_threaded_get(room_name)
	var room_instance : Sala = scene.instantiate()
	room_instance.position = position_sala
	get_node("/root/World").call_deferred("add_child", room_instance)
	await room_instance.ready
	await get_tree().process_frame

	carga = true
	world.get_tree().paused = not get_tree().paused
	world.cargando.start()

	posicionar_protagonista(protagonista_data) #Coloca a la protagonista según los datos del guardado
	emit_signal("partida_cargada") #Emite señal al terminar
	rooms[room_name] = room_instance
#endregion

func reset_world() -> void:
	# Elimina todas las salas cargadas y limpia el diccionario
	for room in rooms.values():
		if is_instance_valid(room):
			room.queue_free()
	rooms.clear()

func start_game():
	new_game = true
	jugando = true
	get_tree().change_scene_to_file("res://Mundo/World.tscn")
	load_room_by_position("res://Mundo/Salas/Superficie/Sala1/Superficie_Sala1.tscn", Vector2(0,0))

func load_game():
	new_game = false
	jugando = true
	get_tree().change_scene_to_file("res://Mundo/World.tscn")
	SaveManager.load_game()

#region Position main character
#Coloca a la protagonista en una posición inicial o cargada
func posicionar_protagonista(data := {}):
	if WorldManager.new_game:
		protagonista.global_position = Vector2(480, 640) #Posición inicial para nueva partida
	else:
		if "position" in data:
			print(data["position"])
			var pos_array = data["position"]
			protagonista.global_position = Vector2(pos_array[0], pos_array[1])

		if "health" in data:
			protagonista.health = data["health"]

		if "coins" in data:
			protagonista.coins = data["coins"] as int

		protagonista.actualizar_monedas()
		protagonista.actualizar_vida()
#endregion
