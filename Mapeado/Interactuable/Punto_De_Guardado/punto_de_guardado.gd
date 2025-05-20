extends StaticBody2D

@onready var texto = $Label
@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var sprite = $Sprite2D
@onready var audio = $AudioStreamPlayer

func _on_area_2d_body_entered(body: Node2D) -> void:
	animated_sprite.visible = true
	animated_sprite.play("guardar")
	SaveManager.save_game(self.global_position)
	sprite.modulate = Color("#5cff59")
	audio.play()


func _on_timer_timeout() -> void:
	texto.visible = false
	sprite.modulate = Color(1,1,1,1)


func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite.visible = false
	texto.visible = true
	timer.start()
