class_name Hud extends CanvasLayer

@onready var health_bar : TextureProgressBar = $Vida/TextureProgressBar
@onready var contador_monedas :  Label = $Monedas/Label
var protagonista : Protagonista

func _ready() -> void:
	GameState.hud = self
	if GameState.protagonista == null:
		GameState.connect("protagonista_ready", Callable(self, "_on_protagonista_ready"))
	else:
		_on_protagonista_ready()

func _on_protagonista_ready():
	protagonista = GameState.protagonista
	protagonista.connect("coins_changed", Callable(self, "_on_coin_recolected"))
	protagonista.connect("health_changed", Callable(self, "_on_health_changed"))

func _on_coin_recolected():
	contador_monedas.text = str(protagonista.coins)

func _on_health_changed():
	health_bar.value = protagonista.health
