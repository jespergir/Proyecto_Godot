extends CharacterBody2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast_suelo : RayCast2D = $RayCast2D
@onready var walking : bool = false
@onready var jumping : bool = false
@onready var landing : bool = false
@onready var falling : bool = false

const SPEED = 300.0 #Velocidad del personaje
const JUMP_VELOCITY = -450.0 #Fuerza del salto
const COYOTE_TIME = 0.2 #El tiempo que se podrá saltar tras abandonar el suelo.
const JUMP_BUFFER_TIME = 0.1 #El tiempo que se almacenará el salto para ser ejecutado.
const JUMP_CUT_MULTIPLIER = 0.5 #Cuánto se reduce el salto cuando sueltas el botón (Salto de altura variable).

var coyote_timer : float = 0.0 #El timer que controlará el coyote time.
var jump_buffer_timer : float = 0.0 #El timer que controlará el jump buffer time.
var falling_time : float = 0.0

func _ready() -> void:
	animated_sprite.play("idle")	

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_animations()

func handle_movement(delta: float) -> void: #Función para controlar el movimiento.
	
	if is_on_floor(): #Comprueba que está en el suelo y marca jumping y falling como false.
		jumping=false
		falling=false
		coyote_timer = COYOTE_TIME #Cuando está en el suelo el timer vale el tiempo total de coyote time.
	else: #Cuando está en el aire le aplica la gravedad.
		velocity += get_gravity() * delta
		
		if velocity.y>=0 and !raycast_suelo.is_colliding() and coyote_timer<=0: #Si tiene velocidad positiva en y, no está colisionando el raycast y el coyote_timer es menor que 0.
			falling = true #Marca falling como true.
		elif raycast_suelo.is_colliding() and velocity.y>0: #Si el raycast sí está colisionando y la velocidad en y es positiva, marca landing como true.
			landing=true
		if falling: #Si está cayendo, suma tiempo a falling time.
			falling_time +=delta
		if coyote_timer > 0: #Cuando el personaje está en el aire (si el coyote timer es mayor que 0).
			coyote_timer -= delta #Le va restando el tiempo que ha pasado desde el anterior frame, cuando llegue a 0, no se podrá saltar.
	
	if jump_buffer_timer > 0:
		jump_buffer_timer -=delta #Le va restando el tiempo que ha pasado desde el anterior frame, cuando llegue a 0, no se podrá saltar.
	
	if Input.is_action_just_pressed("Saltar"): #Cuando se acaba de pulsar saltar, se almacena en buffer.
		jump_buffer_timer = JUMP_BUFFER_TIME
	
	if jump_buffer_timer > 0 and coyote_timer > 0: #Si el hay salto en el buffer y hace muy poco que abandonamos el suelo, permite saltar.
		jumping = true
		velocity.y = JUMP_VELOCITY
		coyote_timer=0 #Consumimos el salto
		jump_buffer_timer=0 #Consumimos el salto
	
	if Input.is_action_just_released("Saltar"): #Cuando se acaba de soltar el botón de saltar.
		velocity.y *= JUMP_CUT_MULTIPLIER #Acorta el salto multiplicando la velocidad en y por JUMP_CUT_MULTIPLIER
	
	#Obtiene la dirección que se está pulsando.
	var direction := Input.get_axis("Izquierda", "Derecha")
	
	if direction: #Comprueba si hay dirección.
		velocity.x = direction * SPEED #Le aplica la velocidad a la dirección.
		if velocity.x > 0: #Si se positiva
			animated_sprite.scale = Vector2(1,1) #Voltea al personaje para que mire hacia donde se mueve.
		elif velocity.x < 0: #Si es negativa
			animated_sprite.scale = Vector2(-1,1) #Voltea al personaje para que mire hacia donde se mueve.
		if not walking and not jumping: #Si no está andando ni saltando todavía.
			walking=true #Marca walking como true para que no se llame todo el rato a la animación provocando un reinicio de la misma.
	else: #Si no hay dirección, para al personaje
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if walking:
			walking=false
			
	move_and_slide()
	
func handle_animations() -> void:
	
	if animated_sprite.animation == "landing": #Si se está reproduciendo landing, no hagas nada.
		return
	
	if animated_sprite.animation == "falling" and falling: #Si se está reproduciendo falling, no hagas nada.
		return
		
	if is_on_floor(): #Si está en el suelo.
		if velocity.x == 0: #Si el personaje está quieto, marca walking como false.
			walking = false
			if not animated_sprite.is_playing() or animated_sprite.animation != "idle": #Si no se está reproduciendo una animación o la animación no es idle, reproduce idle.
				animated_sprite.play("idle")
			if landing: #Si está aterrizando, reproduce landing y marca el bool landing como false.
				animated_sprite.play("landing")
				landing = false
		else:
			if walking and is_on_floor(): #Si está andando y está en el suelo.
				animated_sprite.play("walking") #Reproduce la animación de andar.
			if landing:  #Si está aterrizando, reproduce landing y marca el bool landing como false.
				animated_sprite.play("landing")
				landing = false
	else:
		if jumping:
			animated_sprite.play("jump")
		if velocity.y>=0 and !raycast_suelo.is_colliding() and falling_time>1:
			animated_sprite.play("falling")
			falling_time=0



func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "landing":
		if is_on_floor():
			if velocity.x == 0:
				$AnimatedSprite2D.play("idle")
			else:
				$AnimatedSprite2D.play("walking")
		else:
				animated_sprite.play("jump")
