extends CharacterBody2D

@onready var walking : bool = false
@onready var jumping : bool = false

const SPEED = 300.0 #Velocidad del personaje
const JUMP_VELOCITY = -450.0 #Fuerza del salto
const COYOTE_TIME = 0.2 #El tiempo que se podrá saltar tras abandonar el suelo.
const JUMP_BUFFER_TIME = 0.1 #El tiempo que se almacenará el salto para ser ejecutado.
const JUMP_CUT_MULTIPLIER = 0.5 #Cuánto se reduce el salto cuando sueltas el botón (Salto de altura variable).

var coyote_timer : float = 0.0 #El timer que controlará el coyote time.
var jump_buffer_timer : float = 0.0 #El timer que controlará el jump buffer time.

func _ready() -> void:
	$AnimatedSprite2D.play("idle") #Por defecto reproduce idle.

func _physics_process(delta: float) -> void:
	
	#Cuando está en el suelo marca jumping como false.
	if is_on_floor(): 
		jumping=false
		coyote_timer = COYOTE_TIME #Cuando está en el suelo el timer vale el tiempo total de coyote time.
		if not walking: #Cuando no está en el suelo y no está andando reproduce la animación idle.
			$AnimatedSprite2D.play("idle")
	else: #Cuando está en el aire le aplica la gravedad.
		velocity += get_gravity() * delta
		if coyote_timer > 0: #Cuando el personaje está en el aire (si el coyote timer es mayor que 0).
			coyote_timer -= delta #Le va restando el tiempo que ha pasado desde el anterior frame, cuando llegue a 0, no se podrá saltar.
	
	if jump_buffer_timer > 0:
		jump_buffer_timer -=delta #Le va restando el tiempo que ha pasado desde el anterior frame, cuando llegue a 0, no se podrá saltar.
	
	if Input.is_action_just_pressed("Saltar"): #Cuando se acaba de pulsar saltar, se almacena en buffer.
		jump_buffer_timer = JUMP_BUFFER_TIME
	
	if jump_buffer_timer > 0 and coyote_timer > 0: #Si el hay salto en el buffer y hace muy poco que abandonamos el suelo, permite saltar.
		jumping = true
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("jump")
		coyote_timer=0 #Consumimos el salto
		jump_buffer_timer=0 #Consumimos el salto
	
	if Input.is_action_just_released("Saltar"): #Cuando se acaba de soltar el botón de saltar.
		velocity.y *= JUMP_CUT_MULTIPLIER
	
	#Obtiene la dirección que se está pulsando.
	var direction := Input.get_axis("Izquierda", "Derecha")
	
	if direction: #Comprueba si hay dirección.
		velocity.x = direction * SPEED #Le aplica la velocidad a la dirección.
		if velocity.x > 0: #Si se positiva
			$AnimatedSprite2D.scale = Vector2(1,1) #Voltea al personaje para que mire hacia donde se mueve.
		elif velocity.x < 0: #Si es negativa
			$AnimatedSprite2D.scale = Vector2(-1,1) #Voltea al personaje para que mire hacia donde se mueve.
		if not walking and not jumping: #Si no está andando ni saltando todavía.
			$AnimatedSprite2D.play("walking") #Reproduce la animación de andar.
			walking=true #Marca walking como true para que no se llame todo el rato a la animación provocando un reinicio de la misma.
	else: #Si no hay dirección, para al personaje
		velocity.x = move_toward(velocity.x, 0, SPEED)
		walking=false

	move_and_slide()
