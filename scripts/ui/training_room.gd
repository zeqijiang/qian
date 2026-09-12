class_name TrainingRoom
extends Node2D
## Stage backdrop + simple ground line for combat readability.

@export var ground_color: Color = Color(0.18, 0.16, 0.22)
@export var grid_color: Color = Color(0.28, 0.26, 0.34)
@export var accent_color: Color = Color(0.45, 0.15, 0.25)
@export var bg_path: String = "res://assets/stages/port_battle.png"

var _bg: Texture2D
var _bg_rect: Rect2

func _ready() -> void:
	if ResourceLoader.exists(bg_path):
		_bg = load(bg_path)
	# Cover camera view around origin; ground plane stays at y≈280
	_bg_rect = Rect2(-960, -420, 1920, 1080)
	z_index = -10
	queue_redraw()

func _draw() -> void:
	if _bg:
		draw_texture_rect(_bg, _bg_rect, false)
		# Dim so chibi fighters stay readable
		draw_rect(_bg_rect, Color(0, 0, 0, 0.22))
	else:
		draw_rect(_bg_rect, Color(0.08, 0.06, 0.1, 1))
	# Ground band + accent line (matches StaticBody2D at y≈300)
	draw_rect(Rect2(-800, 280, 1600, 40), Color(0.05, 0.04, 0.06, 0.55))
	draw_line(Vector2(-800, 280), Vector2(800, 280), accent_color, 3.0)
	# Soft side vignette
	draw_rect(Rect2(-960, -420, 120, 1080), Color(0, 0, 0, 0.25))
	draw_rect(Rect2(840, -420, 120, 1080), Color(0, 0, 0, 0.25))
