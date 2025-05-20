extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var timer = $Timer

var color1 = Color.DARK_VIOLET
var color2 = Color.DARK_SLATE_BLUE
var color3 = Color.GOLDENROD

var selected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	color_rect.modulate = color1
	selected = color1



func change_color():
	if selected == color1:
		color_rect.modulate = color2
		selected = color2
	elif selected == color2:
		color_rect.modulate = color3
		selected = color3
	else:
		color_rect.modulate = color1
		selected = color1


func _on_timer_timeout() -> void:
	change_color() # Replace with function body.
