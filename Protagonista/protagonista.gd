class_name Protagonista extends CharacterBody2D

enum States { IDLE, WALK, JUMP, FALL, LAND, ATTACK, DAMAGE }
var current_state: States = States.IDLE

@onready var protagonista : Protagonista = self

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast_suelo1 : RayCast2D = $RayCastSuelo1
@onready var raycast_suelo2 : RayCast2D = $RayCastSuelo2
@onready var attack1 : Area2D = $Attack1
@onready var attack1_first_collision : CollisionShape2D = $Attack1/Attack1FirstCollision
@onready var attack1_second_collision : CollisionShape2D = $Attack1/Attack1SecondCollision

const SPEED = 300.0 #Velocidad del personaje
const JUMP_VELOCITY = -475.0 #Fuerza del salto
const COYOTE_TIME = 0.2 #El tiempo que se podrá saltar tras abandonar el suelo.
const JUMP_BUFFER_TIME = 0.2 #El tiempo que se almacenará el salto para ser ejecutado.
const JUMP_CUT_MULTIPLIER = 0.5 #Cuánto se reduce el salto cuando sueltas el botón (Salto de altura variable).

var coyote_timer : float = 0.0 #El timer que controlará el coyote time.
var jump_buffer_timer : float = 0.0 #El timer que controlará el jump buffer time.
var falling_time : float = 0.0

var damage_just_received = false
