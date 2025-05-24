class_name Hud extends CanvasLayer

# Referencias a los elementos de la interfaz
@onready var health_bar : TextureProgressBar = $Vida/TextureProgressBar
@onready var contador_monedas : Label = $Monedas/Label

# Referencia a la protagonista
var protagonista : Protagonista

func _ready() -> void:
	GameState.hud = self #Registra este HUD en GameState
	# Espera a que esté disponible la protagonista
	if GameState.protagonista == null:
		GameState.connect("protagonista_ready", Callable(self, "_on_protagonista_ready"))
	else:
		_on_protagonista_ready()

func _on_protagonista_ready():
	protagonista = GameState.protagonista #Guarda la referencia
	# Conecta las señales personalizadas para actualizar la interfaz cuando cambien monedas o vida
	protagonista.connect("coins_changed", Callable(self, "_on_coin_recolected"))
	protagonista.connect("health_changed", Callable(self, "_on_health_changed"))

#Actualiza el contador de monedas con el valor actual
func _on_coin_recolected():
	contador_monedas.text = str(protagonista.coins)

#Actualiza la barra de vida con el valor actual
func _on_health_changed():
	health_bar.value = protagonista.health
