# EnemigoPeepossMove.gd
class_name EnemigoPeepossMove
extends EnemigoPeepossBaseState

const LOOPS_TARGET := 1

var angle := 0.0
var start_angle := 0.0    # ← guardaremos aquí el ángulo de partida
var movement_speed := 0.8
var loops_done := 0

var center := Vector2.ZERO
var radius_x := 0.0
var radius_y := 0.0

var deathstarted = false
var deathfinished = false

func start():

	# 1) Leemos marcadores y calculamos la elipse (igual que antes)
	var left   = enemigo.left.global_position
	var right  = enemigo.right.global_position
	var top    = enemigo.top.global_position
	var bottom = enemigo.bot.global_position

	center   = Vector2((left.x + right.x) * 0.5,
					   (top.y  + bottom.y) * 0.5)
	radius_x = abs(right.x  - left.x) * 0.5
	radius_y = abs(bottom.y - top.y ) * 0.5

	enemigo.saved_center = center

	# 2) Inicializamos ángulo y contador de vueltas
	angle = -TAU * 0.25      # arrancas “arriba”
	start_angle = angle      # guardamos ese punto inicial
	loops_done = 0

func on_physics_process(delta: float) -> void:
	
	if enemigo.damage_just_received: #Si recibe daño, cambia al estado Idle
		if enemigo.knockback_timer.is_stopped():
			enemigo.knockback_timer.start()
		enemigo.animated_sprite_boss.modulate = Color(0.8,0,0,1) #Les aplica a los sprites color rojo para reflejar el daño
		if enemigo.health <=0:
			enemigo.animation_player.play("Death")

	
	if enemigo.animated_sprite_boss.animation != "Idle":
		enemigo.animated_sprite_boss.play("Idle")
	# 1) Avanzamos el ángulo y movemos
	angle += delta * movement_speed
	var offset = Vector2(cos(angle)*radius_x, sin(angle)*radius_y)
	enemigo.global_position = center + offset

	# 2) Calculamos cuántas vueltas han pasado desde start_angle
	var loops_now = int((angle - start_angle) / TAU)
	if loops_now > loops_done:
		loops_done = loops_now
		if loops_done >= LOOPS_TARGET:
			state_machine.change_to("Attack")
			



func _on_knockback_timer_timeout() -> void:
	print(enemigo.health)
	enemigo.animated_sprite_boss.modulate = Color(1,1,1,1)
	enemigo.damage_just_received=false #Se marca damage_just_received como false.


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	enemigo.animated_sprite_boss.visible = false
	enemigo.animated_sprite_cristal.visible = false
	enemigo.timer.start()


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Interfaces/EndScreen/pantalla_fin.tscn")
