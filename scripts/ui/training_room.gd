class_name TrainingRoom
extends Node2D
## Visual training stage with ground and walls drawn from markers.

@export var ground_color: Color = Color(0.18, 0.16, 0.22)
@export var grid_color: Color = Color(0.28, 0.26, 0.34)
@export var accent_color: Color = Color(0.45, 0.15, 0.25)

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	# Floor
	draw_rect(Rect2(-800, 280, 1600, 40), ground_color)
	draw_line(Vector2(-800, 280), Vector2(800, 280), accent_color, 3.0)
	# Simple back wall grid
	for i in range(-8, 9):
		var x := i * 80.0
		draw_line(Vector2(x, -360), Vector2(x, 280), grid_color, 1.0)
	for j in range(0, 8):
		var y := -360 + j * 80.0
		draw_line(Vector2(-640, y), Vector2(640, y), grid_color, 1.0)
