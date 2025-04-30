class_name EnemigoLunechonBaseState extends BaseState

var enemigo : EnemigoLunechon:
	set(value):
		controlled_node = value
	get:
		return controlled_node

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")

func handle_states(delta):

	if !enemigo.is_on_floor():
		enemigo.velocity.y += gravity * delta

func get_enemy_position():
	return enemigo.global_position

func invert_scale():
	enemigo.animations.scale.x *= -1
	enemigo.node_raycast_entorno.scale.x *= -1
	enemigo.raycast_suelo.force_raycast_update()
	enemigo.raycast_pared.force_raycast_update()

func receive_damage(attacker_position, damage):
	enemigo.health -= damage
	enemigo.knockback_direction = sign(enemigo.global_position.x - attacker_position.x)
	enemigo.damage_just_received=true


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Attack"):
		print("wtf")
		receive_damage(area.global_position, area.get_parent().damage)
