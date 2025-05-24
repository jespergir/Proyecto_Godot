class_name Boton extends StaticBody2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer

enum animaciones {WoodIdle, WoodOpen, BlackIdle, BlackOpen, GoldenIdle, GoldenOpen, SpecialIdle, SpecialOpen}

signal button_down

# Export para ajustar desde el editor
@export var crystal_scene: PackedScene = preload("res://Recogibles/CristalSinLevitacion.tscn")
@export var crystal_count: int = 30
@export var launch_speed: float = 200.0   # velocidad de expulsión en px/s
@export var spread_angle_deg: float = 90  # ángulo total de dispersión

var pulsado := false

func pulsar_boton():
	pulsado = true
	animated_sprite.play("Boton")  # si tienes animación de abrir
	animation_player.play("pulsar")
	emit_signal("button_down")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if pulsado:
		return
	if body.is_in_group("Protagonista"):  # o tu condición para abrir
		pulsar_boton()
