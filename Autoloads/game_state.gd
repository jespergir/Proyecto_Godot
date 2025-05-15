extends Node

signal protagonista_ready

var protagonista:
	set(value):
		protagonista = value
		emit_signal("protagonista_ready")
	get:
		return protagonista
var world
var hud : Hud



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
