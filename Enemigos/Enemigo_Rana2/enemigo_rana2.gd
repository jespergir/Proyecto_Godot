class_name Enemigo
extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var vision_area: Area2D = $Vision
@onready var state_machine: Node = $StateMachine

# Dirección actual del movimiento (-1 izquierda, 1 derecha)
var direction := -1

# Velocidad de movimiento
@export var speed: float = 100.0

# Posiciones de patrulla
@onready var patrol_left_limit: Vector2 = $Patrol_Left.global_position
@onready var patrol_right_limit: Vector2 = $PatrolRight.global_position
