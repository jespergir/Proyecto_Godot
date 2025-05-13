extends CanvasLayer

@onready var contenedor : VBoxContainer = $Control/VBoxContainer
@onready var boton_reanudar : Button = $Control/VBoxContainer/BotonReanudar
@onready var timer : Timer = $Timer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for boton in contenedor.get_children():
		if boton is Button:
			boton.focus_mode = Control.FOCUS_ALL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("Pause"):
		toggle_pause()

func toggle_pause():
	
	get_tree().paused = not get_tree().paused
	visible = get_tree().paused
	
	if visible:
		await get_tree().process_frame
		boton_reanudar.grab_focus()

func _on_boton_cargar_button_down() -> void:
	SaveManager.load_game()

func _on_boton_salir_button_down() -> void:
	get_tree().quit()

func _on_boton_reanudar_button_down() -> void:
	timer.start()


func _on_timer_timeout() -> void:
	toggle_pause()
