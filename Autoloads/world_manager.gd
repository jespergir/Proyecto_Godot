extends Node

var rooms: Dictionary = {}
var precarga_pendiente : Dictionary = {}
var salas_precargadas : Dictionary = {}

#var pendiente = true
#
#var room_name : String
#var ruta_sala : String
#var ancho_sala_siguiente
#var alto_sala_siguiente 
#var posicion_sala_siguiente
#var position_sala_actual
#var ancho_sala_actual
#var altoo_sala_siguiente
#var instancia

enum posiciones {Derecha, Izquierda, Arriba, Abajo}
#
#func _process(_delta):
	#ResourceLoader.load_threaded_request("res://Mundo/Salas/Sala3/Sala3.tscn")
	#precarga_pendiente["Sala3"] = true
	#if pendiente:
		#preaload_room()
	#else:
		#loado()
#
#
#func preaload_room():
	#if precarga_pendiente.has(room_name):
		#var status = ResourceLoader.load_threaded_get_status(ruta_sala)
		#print("jeu")
		#if status == ResourceLoader.THREAD_LOAD_LOADED:
			#var scene = ResourceLoader.load_threaded_get(ruta_sala)
			#instancia = scene.instantiate()
			#instancia.position = Vector2(99999, 99999)
			#get_node("/root/World").call_deferred("add_child", instancia)
			#precarga_pendiente.erase(room_name)
			#salas_precargadas[room_name] = instancia
			#ancho_sala_siguiente = instancia.ancho
			#alto_sala_siguiente = instancia.alto
			#pendiente = false
#
#func conf(room_name: String, position_sala_actual: Vector2, ancho_sala_actual, posicion_sala_siguiente, ruta_sala):
	#self.room_name=room_name
	#self.ruta_sala = ruta_sala
	#self.position_sala_actual = position_sala_actual
	#self.ancho_sala_actual = ancho_sala_actual
	#self.posicion_sala_siguiente = posicion_sala_siguiente
#
#
#func loado():
	#match posicion_sala_siguiente:
		#posiciones.Derecha:
			#instancia.position = position_sala_actual + Vector2(ancho_sala_actual,0)
		#posiciones.Izquierda:
			#instancia.position = position_sala_actual - Vector2(ancho_sala_siguiente,0)
		#posiciones.Arriba:
			#instancia.position = position_sala_actual + Vector2(0,alto_sala_siguiente)
		#posiciones.Abajo:
			#instancia.position = position_sala_actual - Vector2(0,alto_sala_siguiente)
			#
	#rooms[room_name] = instancia


func load_room(room_name: String, position_sala_actual: Vector2, ancho_sala_actual, posicion_sala_siguiente):
	if rooms.has(room_name):
		return
	ResourceLoader.load_threaded_request(room_name)
	var scene = load(room_name)
	var room_instance : Sala = scene.instantiate()
	room_instance.position = Vector2(99999,99999)
	get_node("/root/World").call_deferred("add_child", room_instance)
	await room_instance.ready
	var ancho_sala_siguiente = room_instance.ancho
	var alto_sala_siguiente = room_instance.alto
	
	match posicion_sala_siguiente:
		posiciones.Derecha:
			room_instance.position = position_sala_actual + Vector2(ancho_sala_actual,0)
		posiciones.Izquierda:
			room_instance.position = position_sala_actual - Vector2(ancho_sala_siguiente,0)
		posiciones.Arriba:
			room_instance.position = position_sala_actual + Vector2(0,alto_sala_siguiente)
		posiciones.Abajo:
			room_instance.position = position_sala_actual - Vector2(0,alto_sala_siguiente)
			
	
	rooms[room_name] = room_instance
