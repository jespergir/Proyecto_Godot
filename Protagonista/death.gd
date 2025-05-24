class_name Death extends PlayerBaseState

func start():	
	if not protagonista.animated_sprite.is_playing() or protagonista.animated_sprite.animation != "Death":
		protagonista.animated_sprite.play("Death")

func on_physics_process(delta: float) -> void:
	
	protagonista.velocity.x = move_toward(protagonista.velocity.x, 0, protagonista.SPEED)
	handle_states(delta)
	protagonista.move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	if protagonista.animated_sprite.animation == "Death":
		protagonista.timer.start()


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Interfaces/StartScreen/Start_Screen.tscn")
