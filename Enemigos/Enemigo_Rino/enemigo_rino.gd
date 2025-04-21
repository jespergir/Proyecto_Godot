class_name EnemigoRino extends CharacterBody2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var node_raycast_entorno : Node2D = $NodeRayCastEntorno
@onready var raycast_suelo : RayCast2D = $NodeRayCastEntorno/RayCastSuelo
@onready var raycast_pared : RayCast2D = $NodeRayCastEntorno/RayCastPared
@onready var protagonista = get_tree().get_nodes_in_group("Protagonista")[0]

const SPEED = 150.0 #Velocidad del personaje
const WALK_TIME = 3
const IDLE_TIME = 2
const KNOCKBACK_TIME = 0.5

var idling_time = 0
var walking_time = 0
var knockback_timer = 0

var direction
var last_direction

var damage_just_received = false
var hitted = false

var knockback_direction
var protagonista_position

func get_enemy_position():
	return global_position

func invert_scale():
	animated_sprite.scale.x *= -1
	node_raycast_entorno.scale.x *= -1
	raycast_suelo.force_raycast_update()
	raycast_pared.force_raycast_update()

func damage(attacker_position):
	knockback_direction = sign(global_position.x - attacker_position.x)
	damage_just_received=true


func _on_area_damage_area_entered(area: Area2D) -> void:
	protagonista_position = area.global_position
	damage(area.position)
