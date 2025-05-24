class_name EnemigoPeepossIdle extends EnemigoPeepossBaseState

func enter():
	enemigo.velocity = Vector2.ZERO #Al entrar en Idle, se detiene completamente el movimiento del jefe

func physics_process(delta):
	#Si no está reproduciendo la animación "Idle", la reproduce
	if enemigo.animated_sprite_boss.animation != "Idle":
		enemigo.animated_sprite_boss.play("Idle")

func _on_area_start_body_entered(body: Node2D) -> void:
	#Si la protagonista entra en el área de activación, cambia al estado Move
	if body.name == "Protagonista":
		state_machine.change_to("Move") #Pasamos al siguiente estado: movimiento
		#Desconecta la señal para que no se vuelva a ejecutar
		enemigo.area_start.disconnect("body_entered", Callable(self, "_on_area_start_body_entered"))
