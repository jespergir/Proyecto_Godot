class_name Enemigo extends CharacterBody2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast_vision : RayCast2D = $RayCastVision
@onready var attack_range_area : Area2D = $AttackRangeArea
@onready var attack_collision_area : Area2D = $AttackCollisionArea
@onready var attack_collision : CollisionShape2D = $AttackCollisionArea/AttackCollision
@onready var attack_range : CollisionShape2D = $AttackRangeArea/AttackRange
@onready var protagonista = get_tree().get_nodes_in_group("Protagonista")[0]

const SPEED = 150.0 #Velocidad del personaje
const WALK_TIME = 3
const IDLE_TIME = 2
const CHASE_TIME = 1
const ATTACK_COOLDOWN = 2

var idling_time = 0
var walking_time = 0
var chasing_time = 0
var attack_cooldown_time = 0
var last_direction

var can_attack = false
var damage_just_received = false

func _physics_process(delta: float) -> void:
	
	attack_cooldown_time-=delta

	if not is_on_floor(): #Comprueba que está en el suelo.
		velocity += get_gravity() * delta
	

func invertir_escala():
	animated_sprite.scale.x *= -1
	attack_collision_area.scale.x *= -1
	attack_range_area.scale.x *= -1
	raycast_vision.target_position.x *= -1
