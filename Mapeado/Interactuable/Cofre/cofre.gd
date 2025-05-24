class_name Cofre extends StaticBody2D

# Referencia al sprite animado del cofre
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

# Enum con las animaciones posibles del cofre (por si cambian según el tipo)
enum animaciones {WoodIdle, WoodOpen, BlackIdle, BlackOpen, GoldenIdle, GoldenOpen, SpecialIdle, SpecialOpen}

# Export variables configurables desde el editor
@export var crystal_scene: PackedScene = preload("res://Recogibles/CristalSinLevitacion.tscn") #Escena del cristal
@export var crystal_count: int = 30 #Número de cristales que expulsa
@export var launch_speed: float = 200.0 #Velocidad de expulsión de los cristales
@export var spread_angle_deg: float = 90 #Ángulo de dispersión de los cristales

var opened := false #Indica si el cofre ya ha sido abierto

#Función que abre el cofre y reproduce su animación
func abrir_cofre():
	opened = true
	animated_sprite.play("BlackOpen") #Reproduce la animación de abrir el cofre negro

#Cuando la protagonista entra en el área del cofre
func _on_area_2d_body_entered(body: Node2D) -> void:
	if opened:
		return #Si ya está abierto, no hace nada
	if body.is_in_group("Protagonista"): #Si el cuerpo pertenece a la protagonista
		abrir_cofre()

#Cuando finaliza la animación de apertura, lanza los cristales
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "BlackOpen":

		# Lanza múltiples cristales en distintas direcciones
		for i in crystal_count:
			var cristal = crystal_scene.instantiate()
			get_parent().add_child(cristal) #Añade el cristal a la escena actual
			cristal.global_position = global_position #Posiciona el cristal en el centro del cofre

			#Calcula dirección aleatoria dentro del ángulo de dispersión
			var half_spread = deg_to_rad(spread_angle_deg) * 0.5
			var base_angle = -PI * 0.5 #Dispara hacia arriba
			var angle = base_angle + randf_range(-half_spread, half_spread)

			#Aplica movimiento dependiendo del tipo de nodo
			if cristal is RigidBody2D:
				cristal.linear_velocity = Vector2.RIGHT.rotated(angle) * launch_speed
			elif cristal.has_method("launch"):
				cristal.launch(Vector2.RIGHT.rotated(angle) * launch_speed)
			# En caso contrario, el cristal podría autogestionarse en su _physics_process
