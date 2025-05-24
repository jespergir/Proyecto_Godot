extends Area2D

#Cuando la protagonista entra en el área
func _on_body_entered(body: Node2D) -> void:
	# Si es la protagonista y la música actual no es la del inicio
	if body.is_in_group("Protagonista") and AudioManager.audio.stream.resource_path != AudioManager.musicainicio.resource_path:
		AudioManager.audio.stream = AudioManager.musicainicio #Cambia la música a la del inicio

	# Si la música no se está reproduciendo, la reproduce
	if not AudioManager.audio.playing:
		AudioManager.audio.play()
