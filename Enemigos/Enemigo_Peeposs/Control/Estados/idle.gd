class_name EnemigoPeepossIdle extends EnemigoPeepossBaseState

func enter():
	enemigo.velocity = Vector2.ZERO

func physics_process(delta):
	if enemigo.animated_sprite_boss.animation != "Idle":
		enemigo.animated_sprite_boss.play("Idle")

func _on_area_start_body_entered(body: Node2D) -> void:
	if body.name == "Protagonista":
		state_machine.change_to("Move") # Pasamos al siguiente estado: movimiento
		enemigo.area_start.disconnect("body_entered", Callable(self, "_on_area_start_body_entered"))
		
