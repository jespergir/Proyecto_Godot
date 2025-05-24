# EnemigoPeepossAttack.gd
class_name EnemigoPeepossAttack
extends EnemigoPeepossBaseState

@export var projectile_scene    : PackedScene = preload("res://Recogibles/Cristal2.tscn")
@export var bullets_per_wave    := 12
@export var waves               := 8
@export var wave_delay          := 0.3
@export var move_duration       := 0.5

signal attack_ready

var sala_attack_center : Marker2D

func start():
	
	enemigo.animated_sprite_boss.play("Attack")
	
	# 1) Localiza la sala y el marker
	var sala = enemigo.get_parent().get_parent()
	sala_attack_center = sala.get_node("Marker_Bullets")

	# 2) Guarda la posición previa del boss
	var return_pos = enemigo.global_position

	# 3) Tween suave al centro de ataque
	var center = sala_attack_center.global_position
	var tween = get_tree().create_tween()
	tween.tween_property(enemigo, "global_position", center, move_duration) \
		 .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	await attack_ready
	# 4) Dispara la espiral
	await _spawn_spiral()

	# 5) Tween de vuelta a la posición previa
	var tween2 = get_tree().create_tween()
	tween2.tween_property(enemigo, "global_position", return_pos, move_duration) \
		  .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	await tween2.finished

	# 6) Volvemos a Move
	state_machine.change_to("Move")

func _spawn_spiral():
	# Nodo sala donde añadir los proyectiles
	var sala = enemigo.get_parent().get_parent()
	var marker = sala_attack_center

	# Offset angular entre cada bala y entre cada wave
	var angle_between    = TAU / bullets_per_wave
	var wave_offset_step = TAU / (bullets_per_wave * waves)

	for w in range(waves):
		var base_offset = wave_offset_step * w

		for i in range(bullets_per_wave):
			var ang = base_offset + i * angle_between
			var dir = Vector2(cos(ang), sin(ang))

			var proj = projectile_scene.instantiate()
			# Spawn desde la posición LOCAL del marker en la sala
			sala.add_child(proj)
			proj.position = marker.position
			proj.call_deferred("initialize", dir)

		await get_tree().create_timer(wave_delay).timeout

	return null


func _on_animated_sprite_cristal_animation_finished() -> void:
	if enemigo.animated_sprite_cristal.animation== "waves":
		enemigo.animated_sprite_cristal.play("charge")
	elif enemigo.animated_sprite_cristal.animation== "charge":
		enemigo.animated_sprite_cristal.visible = false
		emit_signal("attack_ready")


func _on_animated_sprite_boss_animation_finished() -> void:
	if enemigo.animated_sprite_boss.animation == ("Attack"):
		enemigo.animated_sprite_cristal.visible = true
		enemigo.animated_sprite_cristal.play("waves")
