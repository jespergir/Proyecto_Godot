extends AudioStreamPlayer

var audio : AudioStreamPlayer

#Carga anticipadamente la música del inicio y la del jefe
var musicainicio = preload("res://Recursos/Music/FREE Action Music Pack/FREE Action Music Pack/1. Winning Sight.wav")
var musicajefe = preload("res://Recursos/Music/FREE Action Music Pack/FREE Action Music Pack/4. Pow Pow Lazers.wav")

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS #Hace que esta escena no sea pausable

	#region Audio Ready
	#Si GameState aún no tiene referencia al audio, conecta la señal para esperar a que esté listo
	if GameState.audio == null:
		GameState.connect("audio_ready", Callable(self, "_on_audio_ready"))
	else:
		_on_audio_ready() #Si ya está listo, llama directamente a la función
	#endregion

func _on_audio_ready():
	audio = GameState.audio #Guarda la referencia al nodo de audio desde GameState
