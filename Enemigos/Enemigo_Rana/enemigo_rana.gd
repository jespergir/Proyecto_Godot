class_name EnemigoRana extends CharacterBody2D

enum States { IDLE, WALK, CHASE, ATTACK }
var current_state: States = States.IDLE

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var vision_enemigo : Node2D = $VisionEnemigo
@onready var node_raycast_entorno : Node2D = $NodeRayCastEntorno
@onready var raycast_suelo : RayCast2D = $NodeRayCastEntorno/RayCastSuelo
@onready var raycast_pared : RayCast2D = $NodeRayCastEntorno/RayCastPared
@onready var attack_collision_area : Area2D = $AttackCollisionArea
@onready var attack_collision : CollisionShape2D = $AttackCollisionArea/AttackCollision
@onready var protagonista = get_tree().get_nodes_in_group("Protagonista")[0]

const SPEED = 150.0 #Velocidad del personaje
const WALK_TIME = 3
const IDLE_TIME = 2
const CHASE_TIME = 2
const ATTACK_COOLDOWN = 2
const CAST_ATTACK_TIME = 1

var idling_time = 0
var walking_time = 0
var chasing_time = 0
var attack_cooldown_time = 0
var cast_attack_timer

var can_attack = false
var damage_just_received = false

var walking = false
var chasing = false
var direction
var last_direction
var protagonista_direction
var knockback_direction

func invert_scale():
	animated_sprite.scale.x *= -1
	attack_collision_area.scale.x *= -1
	vision_enemigo.scale.x *= -1
	node_raycast_entorno.scale.x *= -1
	raycast_suelo.force_raycast_update()
	raycast_pared.force_raycast_update()

func is_protagonista_visible() -> bool:
	for ray in vision_enemigo.get_children():
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider.is_in_group("Protagonista"):
				return true
	return false

func damage(attacker_position):
	knockback_direction = sign(global_position.x - attacker_position.x)
	damage_just_received=true
