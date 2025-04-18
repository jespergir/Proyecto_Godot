class_name Enemigo extends CharacterBody2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var attack1 : Area2D = $Attack
@onready var attack1_collision : CollisionShape2D = $Attack1/Attack1Collision

const SPEED = 300.0 #Velocidad del personaje

func _physics_process(delta: float) -> void:
	
	if not is_on_floor(): #Comprueba que está en el suelo.
		velocity += get_gravity() * delta
