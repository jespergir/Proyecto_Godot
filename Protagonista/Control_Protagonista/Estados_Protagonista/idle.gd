extends PlayerFeaturesBaseState

func start():	
	if not protagonista.animated_sprite.is_playing() or protagonista.animated_sprite.animation != "idle":
		protagonista.animated_sprite.play("idle")

func on_physics_process(delta: float) -> void:

	# La velocidad de la protagonista en x es 0
	protagonista.velocity.x = move_toward(protagonista.velocity.x, 0, protagonista.SPEED)
		
	# Si se pulsa la acción saltar, la almacena en búfer y si pasa poco rato hasta que se puede saltar, cambia a Saltar
	if Input.is_action_just_pressed("Saltar"):
		protagonista.jump_buffer_timer = protagonista.JUMP_BUFFER_TIME

	if protagonista.jump_buffer_timer > 0 and protagonista.coyote_timer > 0:
		state_machine.change_to("Jump")
		return
	
	# Si se pulsa Izquierda o Derecha, cambia a walk
	var direction := Input.get_axis("Izquierda", "Derecha")
	if direction:
		state_machine.change_to("Walk")
		return
	
	handle_features(delta)
	handle_gravity(delta)
	protagonista.move_and_slide()
