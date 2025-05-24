extends Area2D

@onready var audio = $AudioStreamPlayer

const DAMAGE = 20

@export var speed: float = 400.0
var velocity: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	position += velocity * delta

func initialize(dir: Vector2) -> void:
	velocity = dir * speed
