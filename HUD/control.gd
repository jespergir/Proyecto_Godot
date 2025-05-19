extends Control

var sala_sprite := preload("res://Recursos/Minimapa/sala.png")
var sala_actual_sprite := preload("res://Recursos/Minimapa/sala_actual.png")

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

# Mapa id -> TextureRect para centros exactos
var tile_map: Dictionary = {}

func _ready():
	self.clip_contents = true
	MinimapManager.set_minimap_node(self)

func centrar_y_redibujar_minimapa():
	target_offset = calcular_offset_centrado()
	current_offset = target_offset
	actualizar_sprites()
	queue_redraw()

func limpiar_sprites():
	for c in get_children():
		if c is TextureRect:
			c.queue_free()
	tile_map.clear()

func actualizar_sprites():
	limpiar_sprites()
	var b = _get_map_bounds()
	for id in salas_visitadas.keys():
		if not mapa_salas.has(id):
			continue
		# Posición de la celda
		var rel = (mapa_salas[id] - Vector2(b.min_x, b.min_y)) * TILE_SIZE
		var pos = (rel + current_offset).round() + Vector2(GAP/2.0, GAP/2.0)
		# Elige textura con ternario GDScript
		var tex = sala_actual_sprite if id == sala_actual else sala_sprite
		var tile = TextureRect.new()
		tile.texture = tex
		tile.size = Vector2(SQUARE_SIZE, SQUARE_SIZE)
		tile.position = pos
		tile.expand = true
		tile.stretch_mode = TextureRect.STRETCH_SCALE
		tile.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(tile)
		tile_map[id] = tile

func _get_map_bounds():
	var min_x = 1e9
	var min_y = 1e9
	var max_x = -1e9
	var max_y = -1e9
	for p in mapa_salas.values():
		min_x = min(min_x, p.x)
		min_y = min(min_y, p.y)
		max_x = max(max_x, p.x)
		max_y = max(max_y, p.y)
	return { "min_x":min_x, "min_y":min_y, "max_x":max_x, "max_y":max_y }

func calcular_offset_centrado() -> Vector2:
	var size = Vector2(MINIMAP_WIDTH, MINIMAP_HEIGHT)
	var center = size / 2.0
	if sala_actual == "" or not mapa_salas.has(sala_actual):
		return Vector2.ZERO
	var b = _get_map_bounds()
	var map_w = (b.max_x - b.min_x + 1) * TILE_SIZE
	var map_h = (b.max_y - b.min_y + 1) * TILE_SIZE
	var rel = (mapa_salas[sala_actual] - Vector2(b.min_x, b.min_y)) * TILE_SIZE
	var off = center - rel - Vector2(TILE_SIZE, TILE_SIZE)/2.0
	if map_w <= size.x:
		off.x = (size.x - map_w)/2.0
	else:
		off.x = clamp(off.x, size.x - map_w, 0)
	if map_h <= size.y:
		off.y = (size.y - map_h)/2.0
	else:
		off.y = clamp(off.y, size.y - map_h, 0)
	return off

func _process(delta):
	# Si quieres debug sin retardo, comenta lerp y deja current_offset = target_offset
	current_offset = current_offset.lerp(target_offset, min(1, delta * ANIM_SPEED))
	if current_offset.distance_to(target_offset) > 0.1:
		actualizar_sprites()
		queue_redraw()

func _draw():
	if sala_actual == "" or not mapa_salas.has(sala_actual):
		return
	var color_line = Color.WHITE
	# Recorre cada sala y sus vecinos
	for id in salas_visitadas.keys():
		if not tile_map.has(id):
			continue
		var t1 = tile_map[id]
		var c1 = t1.position + t1.size/2.0
		for dir in [Vector2(1,0), Vector2(0,1)]:
			var target_vec = mapa_salas[id] + dir
			# busca el neighbor
			for other in salas_visitadas.keys():
				if mapa_salas.has(other) and mapa_salas[other] == target_vec:
					var t2 = tile_map[other]
					var c2 = t2.position + t2.size/2.0
					draw_line(c1, c2, color_line, 3)

func set_sala_actual(id_sala:String):
	sala_actual = id_sala
	if not salas_visitadas.has(id_sala):
		salas_visitadas[id_sala] = true
