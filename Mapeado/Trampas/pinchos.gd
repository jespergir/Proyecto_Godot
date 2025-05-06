extends StaticBody2D

const DAMAGE = 10

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Protagonista"):
		var protagonista = body
		protagonista.position = $Marker2D.global_position
