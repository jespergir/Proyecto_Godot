class_name PlayerBaseState extends BaseState

var protagonista : Protagonista:
	set(value):
		controlled_node = value
	get:
		return controlled_node

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")

func handle_states(delta):
	
	if protagonista.is_on_floor() and protagonista.coyote_timer<=0: #Comprueba que está en el suelo.
		protagonista.protagonista.coyote_timer = protagonista.COYOTE_TIME #Cuando está en el suelo el timer vale el tiempo total de coyote time.
	else:
		protagonista.velocity.y += gravity * delta
		if protagonista.coyote_timer > 0: #Cuando el personaje está en el aire (si el coyote timer es mayor que 0).
			protagonista.coyote_timer -= delta
	if Input.is_action_just_pressed("Jump"):
		protagonista.jump_buffer_timer = protagonista.JUMP_BUFFER_TIME
	if protagonista.jump_buffer_timer > 0:
		protagonista.jump_buffer_timer -=delta
	if protagonista.knockback_timer > 0:
		protagonista.knockback_timer -= delta
	else:
		protagonista.invulnerable=false
		

func _on_area_damage_body_entered(body: Node2D) -> void:
#region Daño Enemigo
	if not protagonista.invulnerable and body.is_in_group("Enemigo"):
		protagonista.receive_damage(body.global_position, body.DAMAGE)
		protagonista.invulnerable = true
#endregion
#region Daño Terreno
	if not protagonista.invulnerable and body.is_in_group("Pinchos"):
		protagonista.fade_to_black.visible = true
		protagonista.receive_damage(body.global_position, body.DAMAGE)
		protagonista.invulnerable = true
#endregion

func _on_area_damage_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Recogible"):
		protagonista.coins+=1
		protagonista.actualizar_monedas()

func _on_area_entorno_area_entered(area: Area2D) -> void:
	if area.is_in_group("Area_Sala"):
		var sala_id = area.get_parent().namesala
		print("Entrando en sala con namesala:", sala_id)
		protagonista.nombre_sala_actual = area.get_parent().get_scene_file_path()
		protagonista.posicion_sala_actual = area.get_parent().global_position
		MinimapManager.set_sala_actual(sala_id)
