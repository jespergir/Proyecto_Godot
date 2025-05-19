extends Control

var salas_visitadas: Dictionary = {}
var sala_actual: String = ""
var mapa_salas = MinimapManager.mapa_salas

const TILE_SIZE = 22
const MINIMAP_WIDTH = TILE_SIZE * 6
const MINIMAP_HEIGHT = TILE_SIZE * 4

var current_offset = Vector2.ZERO
var target_offset = Vector2.ZERO
var ANIM_SPEED = 8.0
const GAP = 4
const SQUARE_SIZE = TILE_SIZE - GAP

func _ready():
	self.clip_contents = true
	MinimapManager.set_minimap_node(self)
	# El centrado se hace después de recibir los datos

func centrar_y_redibujar_minimapa():
	target_offset = calcular_offset_centrado()
	current_offset = target_offset
	queue_redraw()

func _get_map_bounds():
	var min_x = 1e9
	var min_y = 1e9
	var max_x = -1e9
	var max_y = -1e9
	for pos in mapa_salas.values():
		min_x = min(min_x, pos.x)
		min_y = min(min_y, pos.y)
		max_x = max(max_x, pos.x)
		max_y = max(max_y, pos.y)
	return {
		"min_x": min_x,
		"min_y": min_y,
		"max_x": max_x,
		"max_y": max_y,
	}

func calcular_offset_centrado() -> Vector2:
	var size = Vector2(MINIMAP_WIDTH, MINIMAP_HEIGHT)
	var center_screen = size / 2.0
	if sala_actual == "" or not mapa_salas.has(sala_actual):
		return Vector2.ZERO

	var bounds = _get_map_bounds()
	var min_x = bounds["min_x"]
	var min_y = bounds["min_y"]
	var max_x = bounds["max_x"]
	var max_y = bounds["max_y"]
	var map_pixel_width = (max_x - min_x + 1) * TILE_SIZE
	var map_pixel_height = (max_y - min_y + 1) * TILE_SIZE

	var sala_pos_rel = (mapa_salas[sala_actual] - Vector2(min_x, min_y)) * TILE_SIZE
	var offset = center_screen - sala_pos_rel - Vector2(TILE_SIZE, TILE_SIZE) / 2.0

	# Centrado si el mapa cabe, clamp si es grande
	if map_pixel_width <= size.x:
		offset.x = (size.x - map_pixel_width) / 2.0
	else:
		offset.x = clamp(offset.x, size.x - map_pixel_width, 0)

	if map_pixel_height <= size.y:
		offset.y = (size.y - map_pixel_height) / 2.0
	else:
		offset.y = clamp(offset.y, size.y - map_pixel_height, 0)

	return offset

func _process(delta):
	current_offset = current_offset.lerp(target_offset, min(1, delta * ANIM_SPEED))
	if current_offset.distance_to(target_offset) > 0.1:
		queue_redraw()

func _draw():
	if sala_actual == "" or not mapa_salas.has(sala_actual):
		return

	var size = Vector2(MINIMAP_WIDTH, MINIMAP_HEIGHT)
	var offset = current_offset

	var border_color = Color("5673fc")
	var color_sala = Color("2e4096")
	var color_sala_actual = Color("7d234d")
	#var glow_color = Color("b7ae70", 0.4)
	var conexion_color = Color("ffffff")

	var bounds = _get_map_bounds()
	var min_x = bounds["min_x"]
	var min_y = bounds["min_y"]

	# Dibuja conexiones entre salas adyacentes
	for id in salas_visitadas.keys():
		if mapa_salas.has(id):
			var sala_vec = mapa_salas[id]
			var sala_pos_rel = (sala_vec - Vector2(min_x, min_y)) * TILE_SIZE
			var sala_pos = (sala_pos_rel + offset).round()
			var centro = sala_pos + Vector2(SQUARE_SIZE, SQUARE_SIZE)/2.0 + Vector2(GAP/2.0, GAP/2.0)
			for dir in [Vector2(1,0), Vector2(0,1)]:
				var vecino = sala_vec + dir
				for other_id in salas_visitadas.keys():
					if mapa_salas.has(other_id) and mapa_salas[other_id] == vecino:
						var vecino_pos_rel = (vecino - Vector2(min_x, min_y)) * TILE_SIZE
						var vecino_pos = (vecino_pos_rel + offset).round()
						var centro_vecino = vecino_pos + Vector2(SQUARE_SIZE, SQUARE_SIZE)/2.0 + Vector2(GAP/2.0, GAP/2.0)
						draw_line(centro, centro_vecino, conexion_color, 3)

	# Dibuja las salas visitadas
	for id in salas_visitadas.keys():
		if mapa_salas.has(id):
			var sala_pos_rel = (mapa_salas[id] - Vector2(min_x, min_y)) * TILE_SIZE
			var sala_pos = (sala_pos_rel + offset).round() + Vector2(GAP/2.0, GAP/2.0)
			var rect = Rect2(sala_pos, Vector2(SQUARE_SIZE, SQUARE_SIZE))
			if rect.intersects(Rect2(Vector2.ZERO, size)):
				draw_rect(rect, color_sala, true)
				draw_rect(rect, border_color, false, 1)

	# Dibuja la sala actual encima
	var sala_actual_pos_rel = (mapa_salas[sala_actual] - Vector2(min_x, min_y)) * TILE_SIZE
	var sala_actual_pos = (sala_actual_pos_rel + offset).round() + Vector2(GAP/2.0, GAP/2.0)
	var actual_rect = Rect2(sala_actual_pos, Vector2(SQUARE_SIZE, SQUARE_SIZE))
	if actual_rect.intersects(Rect2(Vector2.ZERO, size)):
		#draw_rect(actual_rect.grow(2), glow_color.lightened(0.2), true)
		draw_rect(actual_rect, color_sala_actual, true)
		draw_rect(actual_rect, border_color, false, 1)
		draw_circle(sala_actual_pos + Vector2(SQUARE_SIZE/2.0, SQUARE_SIZE/2.0), SQUARE_SIZE/4.0, Color.WHITE)

	#draw_rect(Rect2(Vector2.ZERO, size), border_color, false, 2)

func set_sala_actual(id_sala):
	sala_actual = id_sala
	target_offset = calcular_offset_centrado()
	queue_redraw()



## Posición del cursor de depuración (no afecta al mapa real)
#var debug_pos = Vector2(0, 0)
#
##region Depuración minimapa
#func _ready():
	#self.clip_contents = true
	## Crea la primera sala al iniciar para test
	#var sala_id = "debug_%d_%d" % [debug_pos.x, debug_pos.y]
	#mapa_salas[sala_id] = debug_pos
	#salas_visitadas[sala_id] = true
	#sala_actual = sala_id
	#target_offset = calcular_offset_centrado()
	#current_offset = target_offset
	#queue_redraw()
#
#func _unhandled_input(event):
	## Permite moverse por el minimapa en modo test usando WASD o flechas
	#if event is InputEventKey and event.pressed:
		#var dir = Vector2.ZERO
		#if event.keycode == KEY_RIGHT or event.keycode == KEY_D:
			#dir = Vector2(1, 0)
		#elif event.keycode == KEY_LEFT or event.keycode == KEY_A:
			#dir = Vector2(-1, 0)
		#elif event.keycode == KEY_UP or event.keycode == KEY_W:
			#dir = Vector2(0, -1)
		#elif event.keycode == KEY_DOWN or event.keycode == KEY_S:
			#dir = Vector2(0, 1)
#
		#if dir != Vector2.ZERO:
			#debug_pos += dir
			#var sala_id = "debug_%d_%d" % [debug_pos.x, debug_pos.y]
			#if not mapa_salas.has(sala_id):
				#mapa_salas[sala_id] = debug_pos
			#salas_visitadas[sala_id] = true
			#sala_actual = sala_id
			#target_offset = calcular_offset_centrado()
			#queue_redraw()
##endregion
