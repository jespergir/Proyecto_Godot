class_name EnemigoPeepossBaseState extends BaseState

#Define de qué tipo es la variable enemigo que se maneja en la máquina de estados
var enemigo : EnemigoPeeposs:
	set(value):
		controlled_node = value
	get:
		return controlled_node

func get_enemy_position(): #Getter para obtener la posición del enemigo
	return enemigo.global_position

func invert_scale(): #Esta función hace que el enemigo (y sus elementos importantes) cambien hacia dónde miran.
	enemigo.animations.scale.x *= -1

func receive_damage(attacker_position, damage): #Función encargada de hacer que el enemigo reciba daño
	enemigo.health -= damage
	enemigo.damage_just_received=true

func _on_area_damage_area_entered(area: Area2D) -> void:
	if area.is_in_group("Attack"):
		receive_damage(area.global_position, area.get_parent().damage)
