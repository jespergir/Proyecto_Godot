# EnemigoPeepossMove.gd
class_name EnemigoPeepossMove
extends EnemigoPeepossBaseState

# Constante que indica cuántas vueltas debe dar antes de atacar
const LOOPS_TARGET := 1

# Variables para el movimiento elíptico
var angle := 0.0
var start_angle := 0.0 #Ángulo de inicio para contar vueltas
var movement_speed := 0.8
var loops_done := 0

# Centro y radios de la elipse
var center := Vector2.ZERO
var radius_x := 0.0
var radius_y := 0.0

# Flags de muerte
var death = false

func start():
	if death:
		return
	# 1) Se obtienen las posiciones de los marcadores para calcular la elipse
	var left   = enemigo.left.global_position
	var right  = enemigo.right.global_position
	var top    = enemigo.top.global_position
	var bottom = enemigo.bot.global_position

	center   = Vector2((left.x + right.x) * 0.5,
					   (top.y  + bottom.y) * 0.5)
	radius_x = abs(right.x  - left.x) * 0.5
	radius_y = abs(bottom.y - top.y ) * 0.5

	enemigo.saved_center = center #Guarda el centro para futuras referencias

	# 2) Inicializa el ángulo de movimiento y resetea vueltas completadas
	angle = -TAU * 0.25 #Empieza desde arriba de la elipse
	start_angle = angle
	loops_done = 0

func on_physics_process(delta: float) -> void:
	if death:
		return
#region Damage
	if enemigo.damage_just_received: #Si ha recibido daño...
		if enemigo.knockback_timer.is_stopped():
			enemigo.knockback_timer.start() #Activa temporizador de knockback

		enemigo.animated_sprite_boss.modulate = Color(0.8, 0, 0, 1) #Tintado rojo por daño

		if enemigo.health <= 0: #Si muere, reproduce animación de muerte
			enemigo.animation_player.play("Death")
#endregion

	#Si no se está reproduciendo Idle, lo hace (es la animación de movimiento)
	if enemigo.animated_sprite_boss.animation != "Idle":
		enemigo.animated_sprite_boss.play("Idle")

#region Movimiento
	# 1) Avanza el ángulo para moverse por la elipse
	angle += delta * movement_speed
	var offset = Vector2(cos(angle) * radius_x, sin(angle) * radius_y)
	enemigo.global_position = center + offset

	# 2) Calcula si se ha completado una vuelta
	var loops_now = int((angle - start_angle) / TAU)
	if loops_now > loops_done:
		loops_done = loops_now
		if loops_done >= LOOPS_TARGET: #Si se alcanzan las vueltas deseadas, cambia a Attack
			state_machine.change_to("Attack")
#endregion

#region Fin de Knockback
func _on_knockback_timer_timeout() -> void:
	print(enemigo.health)
	enemigo.animated_sprite_boss.modulate = Color(1, 1, 1, 1) #Restaura color normal
	enemigo.damage_just_received = false #Reinicia el flag de daño
#endregion

#region Fin de animación Death
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	death = true
	enemigo.timer.start() #Inicia temporizador para transición
#endregion

#region Transición a pantalla final
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Interfaces/EndScreen/pantalla_fin.tscn") #Carga la pantalla final
#endregion
