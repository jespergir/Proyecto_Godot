class_name  EnemigoPeepossWalk extends EnemigoPeepossBaseState

var angle := 0.0
var center_position := Vector2.ZERO
var ellipse_radius_x := 200.0
var ellipse_radius_y := 100.0
var direction := 1 # 1 horario, -1 antihorario
var attack_timer := 0.0
var attack_interval := 0.0

func start():
	# Guardamos el centro de la elipse al entrar
	center_position = enemigo.global_position
	
	# Elegimos sentido aleatorio
	direction = [-1, 1].pick_random()

	# Inicializamos el ángulo
	angle = 0.0
	
	# Tiempo hasta siguiente ataque
	attack_interval = randf_range(3.0, 6.0)
	attack_timer = 0.0
	
	## Reproducimos animaciones si hace falta
	#enemigo.animated_sprite1.play("Float")
	#enemigo.animated_sprite2.play("Float")

func on_physics_process(delta: float) -> void:
	# Movimiento elíptico
	angle += delta * direction
	var offset = Vector2(
		cos(angle) * ellipse_radius_x,
		sin(angle) * ellipse_radius_y
	)
	enemigo.global_position = center_position + offset

	# Temporizador para lanzar ataque
	attack_timer += delta
	if attack_timer >= attack_interval:
		state_machine.change_to("Attack")
		return

	# Daño
	if enemigo.damage_just_received:
		state_machine.change_to("Damage")
		return
		
	handle_states(delta)
	enemigo.move_and_slide()
