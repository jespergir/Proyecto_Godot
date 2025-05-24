extends AudioStreamPlayer

#Cuando el nodo entra en el árbol de la escena
func _ready() -> void:
	GameState.audio = self #Guarda la referencia en GameState para que otros nodos puedan acceder al audio
	volume_db = -18 #Ajusta el volumen inicial
	stream = AudioManager.musicainicio #Establece la música inicial al iniciar la escena

#Cuando termina la pista de audio, la reproduce en bucle
func _on_finished() -> void:
	play()
