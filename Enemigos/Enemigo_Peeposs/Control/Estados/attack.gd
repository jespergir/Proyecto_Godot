# EnemigoPeepossAttack.gd
class_name EnemigoPeepossAttack
extends EnemigoPeepossBaseState

# Configuración exportada para el ataque
@export var projectile_scene    : PackedScene = preload("res://Recogibles/Cristal2.tscn")
@export var bullets_per_wave    := 12 #Cantidad de proyectiles por oleada
@export var waves               := 8  #Número total de oleadas
@export var wave_delay          := 0.3 #Tiempo entre oleadas
@export var move_duration       := 0.5 #Duración de los movimientos tween del jefe

signal attack_ready #Señal que indica que se puede comenzar el ataque

# Nodo marcador que indica el centro del ataque en la sala
var sala_attack_center : Marker2D

func start():
	enemigo.animated_sprite_boss.play("Attack") #Reproduce animación de ataque

	# 1) Localiza la sala y el marker donde deben generarse los proyectiles
	var sala = enemigo.get_parent().get_parent()
	sala_attack_center = sala.get_node("Marker_Bullets")

	# 2) Guarda la posición actual del boss para volver luego
	var return_pos = enemigo.global_position

	# 3) Se mueve suavemente al centro de ataque con Tween
	var center = sala_attack_center.global_position
	var tween = get_tree().create_tween()
	tween.tween_property(enemigo, "global_position", center, move_duration) \
		 .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

	await attack_ready #Espera a que finalice la animación del cristal antes de atacar

	# 4) Lanza proyectiles en espiral
	await _spawn_spiral()

	# 5) Vuelve suavemente a su posición original
	var tween2 = get_tree().create_tween()
	tween2.tween_property(enemigo, "global_position", return_pos, move_duration) \
		  .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	await tween2.finished

	# 6) Cambia al estado Move una vez finalizado el ataque
	state_machine.change_to("Move")

#region Ataque espiral
func _spawn_spiral():
	var sala = enemigo.get_parent().get_parent()
	var marker = sala_attack_center

	# Cálculo de ángulos entre balas y desplazamiento angular por oleada
	var angle_between    = TAU / bullets_per_wave
	var wave_offset_step = TAU / (bullets_per_wave * waves)

	for w in range(waves):
		var base_offset = wave_offset_step * w

		for i in range(bullets_per_wave):
			var ang = base_offset + i * angle_between
			var dir = Vector2(cos(ang), sin(ang)) #Dirección del proyectil

			var proj = projectile_scene.instantiate()
			sala.add_child(proj) #Se añade el proyectil a la sala
			proj.position = marker.position #Desde la posición del marcador
			proj.call_deferred("initialize", dir) #Inicializa la dirección del disparo

		await get_tree().create_timer(wave_delay).timeout #Espera antes de la siguiente oleada

	return null
#endregion

#region Animaciones de cristal
#Al terminar la animación "waves", empieza "charge". Al terminar "charge", esconde el sprite y emite señal
func _on_animated_sprite_cristal_animation_finished() -> void:
	if enemigo.animated_sprite_cristal.animation == "waves":
		enemigo.animated_sprite_cristal.play("charge")
	elif enemigo.animated_sprite_cristal.animation == "charge":
		enemigo.animated_sprite_cristal.visible = false
		emit_signal("attack_ready") #Permite lanzar la espiral
#endregion

#region Animación de ataque principal
#Cuando termina la animación de ataque del boss, muestra y activa la animación del cristal
func _on_animated_sprite_boss_animation_finished() -> void:
	if enemigo.animated_sprite_boss.animation == "Attack":
		enemigo.animated_sprite_cristal.visible = true
		enemigo.animated_sprite_cristal.play("waves")
#endregion
