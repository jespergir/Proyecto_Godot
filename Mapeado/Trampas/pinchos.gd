extends StaticBody2D

# Daño que representa la trampa (no se aplica directamente aquí, pero puede usarse en el futuro)
const DAMAGE = 10

#Cuando la protagonista entra en el área de la trampa
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Protagonista"): #Solo reacciona si el cuerpo pertenece al grupo "Protagonista"
		var protagonista = body
		protagonista.position = $Marker2D.global_position #Teletransporta a la protagonista a la posición del marcador (punto de reinicio)
