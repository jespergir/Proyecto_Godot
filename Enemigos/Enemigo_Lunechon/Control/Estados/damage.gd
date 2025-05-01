class_name EnemigoLunechonDamage extends EnemigoLunechonBaseState

var deathstarted = false
var deathfinished = false

func start(): #Al comienzo, inicia el contador del empujón de retroceso (knockback_timer)
	enemigo.knockback_timer = enemigo.KNOCKBACK_TIME #Inicia el contador de tiempo de retoceso
	enemigo.animated_sprite1.modulate = Color(0.8,0,0,1) #Les aplica a los sprites color rojo para reflejar el daño
	enemigo.animated_sprite2.modulate = Color(0.8,0,0,1)
	if enemigo.direction < enemigo.knockback_direction:
		enemigo.velocity.x = enemigo.knockback_direction * (enemigo.SPEED/2) #Le aplica al enemigo empuje hacia atrás
	else:
		enemigo.velocity.x += enemigo.knockback_direction * (enemigo.SPEED/2) #Le aplica al enemigo empuje hacia atrás 
		
func on_physics_process(delta: float) -> void:
	
	enemigo.knockback_timer -= delta #Resta tiempo del contador
	
	if enemigo.health <=0 and not deathstarted: #Si el no tiene vida y no ha empezado la animación de muerte
		deathstarted = true #Activa deathstarted
		enemigo.animated_sprite1.play("Idle") #El enemigo reproduce la animación de estar quieto (Idle)
		enemigo.animated_sprite2.play("Idle")
		enemigo.animation_player.play("Death") #El enemigo empieza la animación de muerte
		enemigo.collision_shape.disabled = true #Se desactiva la colisión con el enemigo
		return
		
	if enemigo.knockback_timer <=0 and not deathstarted: #Si ha terminado el empujón y el enemigo no ha muerto
		enemigo.animated_sprite1.modulate = Color(1,1,1,1) #Vuelve a su color normal
		enemigo.animated_sprite2.modulate = Color(1,1,1,1)
		enemigo.damage_just_received=false #Se marca damage_just_received como false
		enemigo.hitted = true #Se marca hitted como false
		if enemigo.health!=0: #Si no ha muerto, cambia al estado Walk
			state_machine.change_to("Walk")
			return
	if enemigo.knockback_timer <=0 and deathstarted: #Si ha terminado el empujón y ha muerto
		enemigo.velocity.x = move_toward(enemigo.velocity.x, 0, enemigo.SPEED) #Se asegura de que el enemigo se detenga
	if not deathstarted: #Si no ha muerto, se le sigue aplicando la gravedad
		handle_states(delta)
		
	enemigo.move_and_slide()


func spawn_cristal(): #Se encarga de instanciar un cristal en la posición en la que muere el enemigo
	var spawn_position = enemigo.global_position
	var cristal = enemigo.cristal.instantiate()
	cristal.global_position = enemigo.item_spawn.global_position
	get_tree().current_scene.add_child(cristal) # MUY importante: añadirlo directo

#Se encarga de cambiar a la animación explosión cuando el enemigo ya ha caído al suelo.
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	enemigo.velocity.x = 0 #Se asegura de que el enemigo siga quieto
	if anim_name == "Death":
		enemigo.animation_player.pause()
		enemigo.animated_sprite1.rotation = 0
		enemigo.animated_sprite1.play("Explosion")
		return

#Cuando acaba la explosión del enemigo, lo hace desaparecer y lo libera de la memoria
func _on_animated_sprite_up_animation_finished() -> void:
	enemigo.velocity.x = 0
	if enemigo.animated_sprite1.animation == "Explosion":
		enemigo.call_deferred("queue_free")
