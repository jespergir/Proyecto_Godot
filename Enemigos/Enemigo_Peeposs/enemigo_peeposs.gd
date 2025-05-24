class_name EnemigoPeeposs extends CharacterBody2D

# Carga la escena del cristal que deja al morir
var cristal : PackedScene = load("res://Recogibles/Cristal.tscn")

# Referencias a nodos hijos necesarios para el comportamiento del jefe
@onready var animations : Node2D = $Animations
@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var item_spawn : Marker2D = $Marker2D
@onready var animated_sprite_boss : AnimatedSprite2D = $Animations/AnimatedSpriteBoss
@onready var animated_sprite_cristal : AnimatedSprite2D = $Animations/AnimatedSpriteCristal
@onready var animation_player : AnimationPlayer = $Animations/AnimationPlayer
@onready var area_start : Area2D = $AreaStart
@onready var protagonista = GameState.protagonista #Referencia directa a la protagonista desde GameState

# Marcadores de posición alrededor del jefe (probablemente para controlar desplazamientos o ataques)
@onready var top = $"../MarkerTop"
@onready var bot = $"../MarkerBot"
@onready var left = $"../MarkerLeft"
@onready var right = $"../MarkerRight"

# Timers para controlar knockback y acciones temporizadas
@onready var knockback_timer : Timer = $KnockbackTimer
@onready var timer : Timer = $Timer

# Centro de posición guardado, posiblemente para calcular trayectorias o reinicios
var saved_center

# Constantes del jefe
const SPEED = 150.0 #Velocidad del jefe
const DAMAGE = 40   #Daño que inflige al golpear

# Variables de dirección
var direction
var last_direction

# Flags para el manejo de daño
var damage_just_received = false
var hitted = false

# Dirección del knockback y posición de la protagonista al momento de ciertas acciones
var knockback_direction
var protagonista_position

# Vida actual del jefe
var health = 150
