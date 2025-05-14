extends Node

var rooms: Dictionary = {}

var protagonista : Protagonista #Se recibe desde el script de World
enum posiciones {Derecha, Izquierda, Arriba, Abajo} #Enum para las direcciones de las salas a instanciar

var temporizador = 0.0
var carga = false

var jugando = false
var new_game = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS #Hace que esta escena no sea pausable

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
func load_room(room_name: String, position_sala_actual: Vector2, ancho_sala_actual, posicion_sala_siguiente):
	
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
			room_instance.position = position_sala_actual - Vector2(0, alto_sala_siguiente)
#endregion
	
	rooms[room_name] = room_instance #Añade la sala al diccionario de salas cargadas
#endregion

#region Load room from save archive
func load_room_by_position(room_name: String, position_sala: Vector2):
	
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
	
	# Posiciona la sala en su sitio
	room_instance.position = position_sala
	get_node("/root/World").call_deferred("add_child", room_instance)
	await room_instance.ready  # Espera que el nodo esté listo
	carga = true
	SaveManager.posicionar_protagonista() # Posiciona a la protagonista
	
	rooms[room_name] = room_instance #Añade la sala al diccionario de salas cargadas
#endregion

func reset_world() -> void:
	# Elimina todas las salas cargadas
	for room in rooms.values():
		if is_instance_valid(room):
			room.queue_free()
	rooms.clear()
