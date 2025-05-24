class_name BaseState extends Node

# Referencia al nodo que vamos a controlar
@onready var controlled_node : Node = self.owner

# Referencia a la máquina de estados
var state_machine : StateMachine

## Región de métodos comunes

# Método que se ejecuta al entrar en el estado
func start():
	pass

# Método que se ejecuta al salir del estado
func end():
	pass

## Fin región

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
