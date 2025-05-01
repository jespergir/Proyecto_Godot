class_name EnemigoLunechonBaseState extends BaseState

#Define de qué tipo es la variable enemigo que se maneja en la máquina de estados
var enemigo : EnemigoLunechon:
	set(value):
		controlled_node = value
	get:
		return controlled_node

#Referencia la gravedad del proyecto
var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")


#Esta función se encarga de aplicar la gravedad al enemigo en cada frame
func handle_states(delta): 
	if !enemigo.is_on_floor():
		enemigo.velocity.y += gravity * delta

func get_enemy_position(): #Getter para obtener la posición del enemigo
	return enemigo.global_position

func invert_scale(): #Esta función hace que el enemigo (y sus elementos importantes) cambien hacia dónde miran.
	enemigo.animations.scale.x *= -1
	enemigo.node_raycast_entorno.scale.x *= -1
	enemigo.raycast_suelo.force_raycast_update()
	enemigo.raycast_pared.force_raycast_update()

func receive_damage(attacker_position, damage): #Función encargada de hacer que el enemigo reciba daño
	enemigo.health -= damage
	enemigo.knockback_direction = sign(enemigo.global_position.x - attacker_position.x)
	enemigo.damage_just_received=true


func _on_area_2d_area_entered(area: Area2D) -> void: #Si la protagonista ataca al enemigo, le aplica daño
	if area.is_in_group("Attack"):
		receive_damage(area.global_position, area.get_parent().damage)
