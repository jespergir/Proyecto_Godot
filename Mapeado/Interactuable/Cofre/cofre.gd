class_name Cofre extends StaticBody2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

enum animaciones {WoodIdle, WoodOpen, BlackIdle, BlackOpen, GoldenIdle, GoldenOpen, SpecialIdle, SpecialOpen}

# Export para ajustar desde el editor
@export var crystal_scene: PackedScene = preload("res://Recogibles/CristalSinLevitacion.tscn")
@export var crystal_count: int = 30
@export var launch_speed: float = 200.0   # velocidad de expulsión en px/s
@export var spread_angle_deg: float = 90  # ángulo total de dispersión

var opened := false

func abrir_cofre():
	opened = true
	animated_sprite.play("BlackOpen")  # si tienes animación de abrir

func _on_area_2d_body_entered(body: Node2D) -> void:
	if opened:
		return
	if body.is_in_group("Protagonista"):  # o tu condición para abrir
		abrir_cofre()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "BlackOpen":
			# Lanza los cristales
		for i in crystal_count:
			var cristal = crystal_scene.instantiate()
			# Añádelo al mundo (puede ser get_parent(), get_tree().current_scene…)
			get_parent().add_child(cristal)
			# Posición inicial: en el centro del cofre
			cristal.global_position = global_position

			# Cálculo de dirección aleatoria dentro de spread_angle_deg
			var half_spread = deg_to_rad(spread_angle_deg) * 0.5
			# Offset del ángulo central (80° arriba, por ejemplo)
			var base_angle = -PI * 0.5
			var angle = base_angle + randf_range(-half_spread, half_spread)

			# Si tu cristal es RigidBody2D:
			if cristal is RigidBody2D:
				cristal.linear_velocity = Vector2.RIGHT.rotated(angle) * launch_speed
			# Si es KinematicBody2D (o CharacterBody2D), podrías:
			elif cristal.has_method("launch"):
				cristal.launch(Vector2.RIGHT.rotated(angle) * launch_speed)
			# O guardarlo internamente y moverlo en _physics_process  
