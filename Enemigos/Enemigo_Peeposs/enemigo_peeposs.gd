class_name EnemigoPeeposs extends CharacterBody2D

var cristal : PackedScene = load("res://Recogibles/Cristal.tscn")

@onready var animations : Node2D = $Animations
@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var item_spawn : Marker2D = $Marker2D
@onready var animated_sprite_boss : Node2D = $Animations/AnimatedSpriteBoss
@onready var animated_sprite_cristal : Node2D = $Animations/AnimatedSpriteCristal
@onready var animation_player : AnimationPlayer = $Animations/AnimationPlayer
@onready var protagonista = GameState.protagonista

const SPEED = 150.0 #Velocidad del personaje
const DAMAGE = 40
const KNOCKBACK_TIME = 0.5

var knockback_timer = 0

var direction
var last_direction

var damage_just_received = false
var hitted = false

var knockback_direction
var protagonista_position

var health = 100
