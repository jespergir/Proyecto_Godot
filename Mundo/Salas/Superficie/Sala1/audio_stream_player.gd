extends AudioStreamPlayer

func _on_area_musica_body_entered(body: Node2D) -> void:
	if body.is_in_group("Protagonista") and not playing:
		play()


func _on_finished() -> void:
	play()
