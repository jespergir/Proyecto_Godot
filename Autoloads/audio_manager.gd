extends AudioStreamPlayer

var audio : AudioStreamPlayer

var musicainicio = preload("res://Recursos/Music/FREE Action Music Pack/FREE Action Music Pack/1. Winning Sight.wav")
var musicajefe = preload("res://Recursos/Music/FREE Action Music Pack/FREE Action Music Pack/4. Pow Pow Lazers.wav")

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS #Hace que esta escena no sea pausable
	if GameState.audio == null:
		GameState.connect("audio_ready", Callable(self, "_on_audio_ready"))
	else:
		_on_audio_ready()

func _on_audio_ready():
	audio = GameState.audio
