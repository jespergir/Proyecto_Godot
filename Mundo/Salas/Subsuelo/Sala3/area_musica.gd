extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Protagonista") and AudioManager.audio.stream.resource_path != AudioManager.musicajefe.resource_path:
		AudioManager.audio.stream=AudioManager.musicajefe
	AudioManager.audio.play()
