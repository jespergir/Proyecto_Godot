extends Node

var rooms: Dictionary = {}

var protagonista : Protagonista
var world
enum posiciones {Derecha, Izquierda, Arriba, Abajo} #Enum para las direcciones de las salas a instanciar

var temporizador = 0.0
var carga = false

var jugando = false
var new_game = false

signal partida_cargada

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS #Hace que esta escena no sea pausable
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
		protagonista.iniciar_variables()

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
	var posicion_protagonista = protagonista.global_position #Referencia la posición global de la protagonista.
	
	for room_name in rooms.keys(): #Recorre el diccionario de las salas
		var room = rooms[room_name]
		if not is_instance_valid(room): #Si una sala del diccionario ya no es una instancia válida, salta esa vuelta del bucle
			continue
			
		var distance = posicion_protagonista.distance_to(room.global_position) #Calcula la distancia de la protagonista a la sala
		
		if distance > 5000:  # Si está muy lejos, se elimina y la saca del diccionario rooms
			room.queue_free()
			rooms.erase(room_name)
#endregion

#region Load room while playing
#Función para cargar salas en tiempo de ejecución
func load_room(room_name: String, position_sala_actual: Vector2, ancho_sala_actual, alto_sala_actual, posicion_sala_siguiente):
	if rooms.has(room_name): #Si la sala ya ha sido cargada, no hagas nada.
		return

	# Solicita la carga en segundo plano
	ResourceLoader.load_threaded_request(room_name)

	# Espera hasta que la carga haya terminado
	while ResourceLoader.load_threaded_get_status(room_name) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await Engine.get_main_loop().process_frame

	# Verifica si se cargó correctamente
	if ResourceLoader.load_threaded_get_status(room_name) != ResourceLoader.THREAD_LOAD_LOADED:
		printerr("Error al cargar la sala: ", room_name)
		return
		
	# Recupera la escena ya cargada
	var scene := ResourceLoader.load_threaded_get(room_name)
	var room_instance : Sala = scene.instantiate()

	# Posiciona inicialmente la sala fuera de la vista
	room_instance.position = Vector2(99999, 99999)
	get_node("/root/World").call_deferred("add_child", room_instance)
	await room_instance.ready  # Espera que el nodo esté listo

	# Calcula su posición final
	var ancho_sala_siguiente = room_instance.ancho
	var alto_sala_siguiente = room_instance.alto
	
#region Match dirección de la siguiente sala
	#En función de la dirección donde toque instanciar la sala, hará una cosa u otra.
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
	
	rooms[room_name] = room_instance #Añade la sala al diccionario de salas cargadas
#endregion

#region Load room from save archive
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

	# ✅ Pasamos los datos del guardado
	posicionar_protagonista(protagonista_data)
	emit_signal("partida_cargada")
	rooms[room_name] = room_instance

#endregion

func reset_world() -> void:
	# Elimina todas las salas cargadas
	for room in rooms.values():
		if is_instance_valid(room):
			room.queue_free()
	rooms.clear()

func start_game():
	new_game=true
	jugando = true
	get_tree().change_scene_to_file("res://Mundo/World.tscn")
	load_room_by_position("res://Mundo/Salas/Superficie/Sala1/Superficie_Sala1.tscn", Vector2(0,0))


func load_game():
	new_game=false
	jugando = true
	get_tree().change_scene_to_file("res://Mundo/World.tscn")
	SaveManager.load_game()


#region Position main character
func posicionar_protagonista(data := {}):
	if WorldManager.new_game:
		protagonista.global_position = Vector2(480, 640)
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
