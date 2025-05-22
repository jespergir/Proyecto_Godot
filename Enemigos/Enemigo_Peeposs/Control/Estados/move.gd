class_name  EnemigoPeepossMove extends EnemigoPeepossBaseState

var angle := 0.0
var direction := 1
var attack_timer := 0.0
var attack_interval := 0.0

var center := Vector2.ZERO
var radius_x := 100.0
var radius_y := 50.0

var movement_speed := 0.8

var ascending := true
var ascend_speed := 60.0

func start():
	var left = enemigo.left.global_position
	var right = enemigo.right.global_position
	var top = enemigo.top.global_position
	var bottom = enemigo.bot.global_position

	center = (left + right) / 2
	center.y = (top.y + bottom.y) / 2
	
	radius_x = abs(right.x - left.x) / 2
	radius_y = abs(bottom.y - top.y) / 2
	
	direction = [-1, 1].pick_random()
	attack_interval = randf_range(3.0, 6.0)
	attack_timer = 0.0
	
func on_physics_process(delta: float) -> void:
	angle += delta * direction * movement_speed
	
	var offset = Vector2(
		cos(angle) * radius_x,
		sin(angle) * radius_y
	)
	enemigo.global_position = center + offset

	#attack_timer += delta
	#if attack_timer >= attack_interval:
		#state_machine.change_to("Attack")
		#return
#
	#if enemigo.damage_just_received:
		#state_machine.change_to("Damage")
		#return


	#attack_timer += delta
	#if attack_timer >= attack_interval:
		#state_machine.change_to("Attack")
		#return
#
	#if enemigo.damage_just_received:
		#state_machine.change_to("Damage")
		#return
