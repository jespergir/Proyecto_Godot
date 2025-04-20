class_name Idle extends PlayerStatesBaseState

func start():	
	if not protagonista.animated_sprite.is_playing() or protagonista.animated_sprite.animation != "Idle":
		protagonista.animated_sprite.play("Idle")

func on_physics_process(delta: float) -> void:

	# La velocidad de la protagonista en x es 0
	protagonista.velocity.x = move_toward(protagonista.velocity.x, 0, protagonista.SPEED)
	

	# Si se pulsa Izquierda o Derecha, cambia a walk
	var direction := Input.get_axis("Left", "Right")
	if direction:
		state_machine.change_to("Walk")
		return
		
		# Si se pulsa la acción saltar, la almacena en búfer y si pasa poco rato hasta que se puede saltar, cambia a Saltar
	if protagonista.jump_buffer_timer > 0 and protagonista.coyote_timer > 0:
		state_machine.change_to("Jump")
		return

	# Si se pulsa la acción saltar, la almacena en búfer y si pasa poco rato hasta que se puede saltar, cambia a Saltar
	if Input.is_action_just_pressed("Attack1"):
		state_machine.change_to("Attack1")
		return
	
	handle_states(delta)
	protagonista.move_and_slide()
