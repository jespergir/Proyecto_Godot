extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.audio = self
	volume_db = -8
	stream = AudioManager.musicainicio

func _on_finished() -> void:
	play()
