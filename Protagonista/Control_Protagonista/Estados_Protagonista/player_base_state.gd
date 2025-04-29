class_name PlayerBaseState extends BaseState

var protagonista : Protagonista:
	set(value):
		controlled_node = value
	get:
		return controlled_node

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")

func handle_states(delta):
	
	if protagonista.is_on_floor() and protagonista.protagonista.coyote_timer<=0: #Comprueba que está en el suelo.
		protagonista.protagonista.coyote_timer = protagonista.COYOTE_TIME #Cuando está en el suelo el timer vale el tiempo total de coyote time.
	else:
		protagonista.velocity.y += gravity * delta
		if protagonista.protagonista.coyote_timer > 0: #Cuando el personaje está en el aire (si el coyote timer es mayor que 0).
			protagonista.protagonista.coyote_timer -= delta
	if Input.is_action_just_pressed("Jump"):
		protagonista.protagonista.jump_buffer_timer = protagonista.JUMP_BUFFER_TIME
	if protagonista.protagonista.jump_buffer_timer > 0:
		protagonista.protagonista.jump_buffer_timer -=delta
	if protagonista.knockback_timer > 0:
		protagonista.knockback_timer -= delta
	else:
		protagonista.invulnerable=false
		

func damage(attacker_position, damage):
	protagonista.health-=damage
	protagonista.hud.health_bar.value=protagonista.health
	if protagonista.knockback_timer <=0:
		protagonista.knockback_direction = sign(protagonista.global_position.x - attacker_position.x)
		protagonista.damage_just_received=true



func _on_area_damage_body_entered(body: Node2D) -> void:
	if not protagonista.invulnerable and body.is_in_group("Enemigo"):
		damage(body.global_position, body.DAMAGE)
		protagonista.invulnerable = true
