class_name Protagonista extends CharacterBody2D

enum States { IDLE, WALK, JUMP, FALL, LAND, ATTACK, DAMAGE }
var current_state: States = States.IDLE

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

func _physics_process(delta: float) -> void:
	
	match current_state:
		States.IDLE:
			idle()
		States.WALK:
			walk(delta)
		States.JUMP:
			jump(delta)
		States.FALL:
			fall()
		States.LAND:
			land()
		States.ATTACK:
			attack()
	
	if is_on_floor() and coyote_timer<=0: #Comprueba que está en el suelo.
		coyote_timer = COYOTE_TIME #Cuando está en el suelo el timer vale el tiempo total de coyote time.
	else:
		velocity += get_gravity() * delta
		if coyote_timer > 0: #Cuando el personaje está en el aire (si el coyote timer es mayor que 0).
			coyote_timer -= delta

	if Input.is_action_just_pressed("Jump"):
		jump_buffer_timer = JUMP_BUFFER_TIME
		
	if jump_buffer_timer > 0:
		jump_buffer_timer -=delta
		
		
		
	move_and_slide()


func idle():
	
	if not animated_sprite.is_playing() or animated_sprite.animation != "Idle":
		animated_sprite.play("Idle")
		
	# La velocidad de la protagonista en x es 0
	velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Si se pulsa Izquierda o Derecha, cambia a walk
	var direction := Input.get_axis("Left", "Right")
	if direction:
		current_state = States.WALK
		return
		
		# Si se pulsa la acción saltar, la almacena en búfer y si pasa poco rato hasta que se puede saltar, cambia a Saltar
	if jump_buffer_timer > 0 and coyote_timer > 0:
		current_state = States.JUMP
		return
		
	# Si se pulsa la acción saltar, la almacena en búfer y si pasa poco rato hasta que se puede saltar, cambia a Saltar
	if Input.is_action_just_pressed("Attack1"):
		current_state = States.ATTACK
		return

func walk(delta):
	
	# Controlar la dirección al andar
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.scale.x = sign(direction)
		attack1.scale.x = sign(direction)
		animated_sprite.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Si se puede saltar
	if jump_buffer_timer > 0 and coyote_timer > 0:
		current_state = States.JUMP
		return	
		
	# Después de un segundo de caída, cambiar a Fall
	if velocity.y>=0 and (!raycast_suelo1.is_colliding() or !raycast_suelo2.is_colliding()) and coyote_timer<=0:
		falling_time +=delta
		if falling_time>0.2:
			falling_time=0
			current_state = States.FALL
			return
			
	if  Input.is_action_just_pressed("Attack1"):
		current_state = States.ATTACK
		return
			
	if not Input.get_axis("Left", "Right"):
		current_state = States.IDLE
		return

func jump(delta):
	
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		animated_sprite.play("Jump")
		falling_time=0
		jump_buffer_timer = 0
		coyote_timer = 0
		
	# Salto variable: si soltó el salto, cortar el salto
	if Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y *= JUMP_CUT_MULTIPLIER
		
	# Controlar la dirección mientras salta
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.scale.x = sign(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if  Input.is_action_just_pressed("Attack1"):
		current_state = States.ATTACK
		return
		
	# Después de un segundo de caída, cambiar a Fall
	if velocity.y>=0 and !(raycast_suelo1.is_colliding() or raycast_suelo2.is_colliding()) and coyote_timer<=0:
		falling_time +=delta
		if falling_time>1:
			falling_time=0
			current_state = States.FALL
			return
	
	# Si la velocidad en y es 0 y está en el suelo, cambiar a Land
	if velocity.y > 0 and (raycast_suelo1.is_colliding() or raycast_suelo2.is_colliding()):
		current_state = States.LAND
		return
		
		
func fall():
	# Controlar la dirección mientras cae
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.scale.x = sign(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Si la velocidad en y es mayor de 0 y el raycast no detecta el suelo, repodruce falling
	if velocity.y>=0 and !(raycast_suelo1.is_colliding() or raycast_suelo2.is_colliding()):
			animated_sprite.play("Fall")
			falling_time=0

	if jump_buffer_timer > 0 and coyote_timer > 0:
		current_state = States.JUMP
		return

	# Si la velocidad en y es 0 y la protagonista está en el suelo, cambia a Land
	if velocity.y > 0 and (raycast_suelo1.is_colliding() or raycast_suelo2.is_colliding()):
		current_state = States.LAND
		return

func land():
	# Controla la dirección en x mientras se aterriza
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.scale.x = sign(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if jump_buffer_timer > 0 and coyote_timer > 0:
		current_state = States.JUMP
		return

	# Si la velocidad en y es mayor que 0 y el raycast está colistionando, aterriza
	if velocity.y > 0 and (raycast_suelo1.is_colliding() or raycast_suelo2.is_colliding()):
		animated_sprite.play("Land")

func attack():
	animated_sprite.play("Attack1")
	
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = animated_sprite.scale.x * SPEED
		animated_sprite.scale.x = sign(direction)
		attack1.scale.x = sign(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Si la velocidad en y es 0 y está en el suelo, cambiar a Land
	if !is_on_floor()  and (raycast_suelo1.is_colliding() or raycast_suelo2.is_colliding()):
		current_state = States.LAND
		return

func damage():
	damage_just_received = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "Attack1":
		current_state = States.IDLE
	if animated_sprite.animation == "Land":
		current_state = States.IDLE
