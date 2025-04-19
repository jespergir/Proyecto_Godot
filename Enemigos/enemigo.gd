class_name Enemigo extends CharacterBody2D

enum States { IDLE, WALK, CHASE, ATTACK }
var current_state: States = States.IDLE

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var vision_enemigo : Node2D = $VisionEnemigo
@onready var raycast_vision1 : RayCast2D = $VisionEnemigo/RayCastVision
@onready var raycast_vision2 : RayCast2D = $VisionEnemigo/RayCastVision2
@onready var raycast_vision3 : RayCast2D = $VisionEnemigo/RayCastVision3
@onready var attack_range_area : Area2D = $AttackRangeArea
@onready var attack_collision_area : Area2D = $AttackCollisionArea
@onready var attack_collision : CollisionShape2D = $AttackCollisionArea/AttackCollision
@onready var protagonista = get_tree().get_nodes_in_group("Protagonista")[0]

const SPEED = 150.0 #Velocidad del personaje
const WALK_TIME = 3
const IDLE_TIME = 2
const CHASE_TIME = 2
const ATTACK_COOLDOWN = 2

var idling_time = 0
var walking_time = 0
var chasing_time = 0
var attack_cooldown_time = 0

var can_attack = false
var damage_just_received = false

var walking = false
var chasing = false
var direction
var last_direction

func _physics_process(delta: float) -> void:
	
	if !is_on_floor():
		velocity += get_gravity() * delta
	attack_cooldown_time -= delta

	match current_state:
			States.IDLE:
				idle(delta)
			States.WALK:
				walk(delta)

	move_and_slide()

func idle(delta):
	
	if not animated_sprite.is_playing() or animated_sprite.animation != "Idle":
		animated_sprite.play("Idle")
		idling_time = IDLE_TIME
	
	idling_time-=delta
	
	# La velocidad de la protagonista en x es 0
	velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if idling_time <= 0:
		current_state = States.WALK

func walk(delta):
	
	if not walking:
		walking=true
		walking_time = WALK_TIME
		last_direction = animated_sprite.scale.x
		invertir_escala()
		
	walking_time -=delta
	
	direction = last_direction * -1
	if direction:
		
		velocity.x = direction * SPEED
		
		if not animated_sprite.is_playing() or animated_sprite.animation != "Walk":
			animated_sprite.play("Walk")
			
	if is_on_wall():
		current_state = States.IDLE
		walking = false
		return
		
	if walking_time <= 0:
		current_state = States.IDLE
		walking = false
		return

func chase():
	
	if not chasing:
		chasing = true
		chasing_time = CHASE_TIME
		
	direction = (protagonista.position - global_position).normalized()
	velocity.x = (direction.x * SPEED*1.5)
	
	animated_sprite.play("Run")	
	
	if is_on_wall():
		current_state = States.IDLE
		chasing = false
		return


func attack():
	if attack_cooldown_time <= 0:
		animated_sprite.play("Attack")
		attack_cooldown_time = ATTACK_COOLDOWN


func invertir_escala():
	animated_sprite.scale.x *= -1
	attack_collision_area.scale.x *= -1
	attack_range_area.scale.x *= -1
	vision_enemigo.scale.x *= -1


func _on_attack_range_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Protagonista"):
		can_attack=true


func _on_attack_range_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Protagonista"):
		can_attack=false

func _on_animated_sprite_2d_frame_changed() -> void:
	var current_frame = animated_sprite.frame
	var current_animation = animated_sprite.animation
	
	if attack_cooldown_time <= 0:
		if current_animation == "Attack" and current_frame == 2:
			attack_collision.disabled=false
		elif current_animation == "Attack" and current_frame == 4:
			attack_collision.disabled = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "Attack":
		current_state = States.IDLE


func _on_attack_collision_area_body_entered(body: Node2D) -> void:
	if attack_cooldown_time <= 0:
		if  body.is_in_group("Protagonista"):
			body.damage()
