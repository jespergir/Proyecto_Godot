extends AudioStreamPlayer

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if not playing:
		play()
