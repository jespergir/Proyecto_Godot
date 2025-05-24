extends StaticBody2D

# Referencias a nodos hijos del punto de guardado
@onready var texto = $Label
@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var sprite = $Sprite2D
@onready var audio = $AudioStreamPlayer

#Cuando la protagonista entra en el área de guardado
func _on_area_2d_body_entered(_body: Node2D) -> void:
	animated_sprite.visible = true #Muestra la animación de guardar
	animated_sprite.play("guardar") #Reproduce la animación
	SaveManager.save_game(self.global_position) #Guarda la partida desde esta posición
	sprite.modulate = Color("#5cff59") #Cambia el color del sprite como indicativo visual
	audio.play() #Reproduce el sonido de guardado

#Cuando termina el temporizador, oculta el texto y restaura el color original
func _on_timer_timeout() -> void:
	texto.visible = false
	sprite.modulate = Color(1,1,1,1)

#Cuando termina la animación de guardado, muestra el texto de confirmación y arranca el temporizador
func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite.visible = false
	texto.visible = true
	timer.start()
