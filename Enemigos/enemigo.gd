class_name Enemigo extends CharacterBody2D

enum States { IDLE, WALK, CHASE, ATTACK }
var current_state: States = States.IDLE

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var vision_enemigo : Node2D = $VisionEnemigo
@onready var node_raycast_entorno : Node2D = $NodeRayCastEntorno
@onready var raycast_suelo : RayCast2D = $NodeRayCastEntorno/RayCastSuelo
@onready var raycast_pared : RayCast2D = $NodeRayCastEntorno/RayCastPared
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
	chasing_time -= delta
	
	match current_state:
			States.IDLE:
				idle(delta)
			States.WALK:
				walk(delta)
			States.CHASE:
				chase()
			States.ATTACK:
				attack()

	move_and_slide()

func idle(delta):
	
	# La velocidad de la protagonista en x es 0
	velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#Si no se está reproduciendo ninguna animación o la animación no es idle, reproduce idle.
	if not animated_sprite.is_playing() or animated_sprite.animation != "Idle":
		animated_sprite.play("Idle")
		idling_time = IDLE_TIME
	
	idling_time-=delta
	
	if attack_cooldown_time<=0 and can_attack:
		current_state = States.ATTACK
		return
	
	if idling_time <= 0:
		current_state = States.WALK
		return
	
	if not can_attack:
		go_chase()

func walk(delta):
	
	if not walking:
		walking = true
		walking_time = WALK_TIME
		invert_scale()
		

	walking_time -= delta
	
	direction = animated_sprite.scale.x
	
	# Al detectar colisión con raycast_pared, invertir la dirección
	if raycast_pared.is_colliding():
		direction = -animated_sprite.scale.x
		invert_scale()  # Ajustar el sprite visualmente
		current_state = States.IDLE
		walking = false
		return

	if direction:
		velocity.x = direction * SPEED

		if not animated_sprite.is_playing() or animated_sprite.animation != "Walk":
			animated_sprite.play("Walk")

	if !raycast_suelo.is_colliding() or raycast_pared.is_colliding():
		current_state = States.IDLE
		walking = false
		return
	
	if attack_cooldown_time<=0 and can_attack:
		current_state = States.ATTACK
		return
	
	if not can_attack:
		go_chase()

	if walking_time <= 0:
		current_state = States.IDLE
		walking = false
		return

func chase():
	
	if not chasing:
		chasing = true
		chasing_time = CHASE_TIME
	
	if is_protagonista_visible() and chasing_time > 0:
		direction = (protagonista.position - global_position).normalized()
		velocity.x = (direction.x * SPEED*1.5)
		animated_sprite.play("Run")	
		
	if attack_cooldown_time<=0 and can_attack:
		current_state = States.ATTACK
		return
		
	if not raycast_suelo.is_colliding() or raycast_pared.is_colliding():
		chasing = false
		current_state = States.IDLE
		velocity.x = 0
		return

	
	for ray in vision_enemigo.get_children():
		if ray.is_colliding():
			var collider = ray.get_collider()
			if !collider.is_in_group("Protagonista") and chasing_time<=0:
				current_state = States.IDLE
				chasing = false
				break
		else:
			if chasing_time<=0:
				current_state = States.IDLE
				chasing = false
				break



func attack():
	if attack_cooldown_time <= 0 and can_attack:
		animated_sprite.play("Attack")
		attack_cooldown_time = ATTACK_COOLDOWN



func invert_scale():
	animated_sprite.scale.x *= -1
	attack_collision_area.scale.x *= -1
	attack_range_area.scale.x *= -1
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

func go_chase():
	if raycast_pared.is_colliding():
		var pared = raycast_pared.get_collider()
		if pared.is_in_group("Protagonista"):
			for ray in vision_enemigo.get_children():
				if ray.is_colliding() and raycast_suelo.is_colliding():
					var collider = ray.get_collider()
					if collider.is_in_group("Protagonista"):
						current_state = States.CHASE
						break
	else:
		for ray in vision_enemigo.get_children():
				if ray.is_colliding() and raycast_suelo.is_colliding():
					var collider = ray.get_collider()
					if collider.is_in_group("Protagonista"):
						current_state = States.CHASE
						break

func _on_attack_range_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Protagonista"):
		can_attack=true


func _on_attack_range_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Protagonista"):
		can_attack=false


func _on_attack_collision_area_body_entered(body: Node2D) -> void:
	if attack_cooldown_time <= 0:
		if  body.is_in_group("Protagonista"):
			body.damage()


func _on_animated_sprite_2d_frame_changed() -> void:
	var current_frame = animated_sprite.frame
	var current_animation = animated_sprite.animation
	
	if current_animation == "Attack":
		if not can_attack:
			current_state = States.IDLE
			return

		if current_frame == 2:
			print("hola2")
			attack_collision.disabled = false
		elif current_frame == 4:
			attack_collision.disabled = true
			print("hola3")
			current_state = States.IDLE
			return
