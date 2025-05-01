class_name EnemigoLunechon extends CharacterBody2D

var cristal : PackedScene = load("res://Recogibles/Cristal.tscn")

@onready var animations : Node2D = $Animations
@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var item_spawn : Marker2D = $Marker2D
@onready var animated_node_up : Node2D = $Animations/AnimatedNodeUp
@onready var animated_sprite1 : AnimatedSprite2D = $Animations/AnimatedNodeUp/AnimatedSpriteUp
@onready var animated_sprite2 : AnimatedSprite2D = $Animations/AnimatedNodeDown/AnimatedSpriteDown
@onready var animation_player : AnimationPlayer = $Animations/AnimationPlayer
@onready var node_raycast_entorno : Node2D = $NodeRayCastEntorno
@onready var raycast_suelo : RayCast2D = $NodeRayCastEntorno/RayCastSuelo
@onready var raycast_pared : RayCast2D = $NodeRayCastEntorno/RayCastPared
@onready var protagonista = get_tree().get_nodes_in_group("Protagonista")[0]

const SPEED = 150.0 #Velocidad del personaje
const DAMAGE = 20
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

var health = 50
