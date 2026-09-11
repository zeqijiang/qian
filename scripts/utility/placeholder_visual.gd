class_name PlaceholderVisual
extends Node2D
## Draws a simple colored character silhouette. Replace with sprites later.

var body_color: Color = Color(0.25, 0.45, 0.95)
var accent_color: Color = Color(0.7, 0.85, 1.0)
var body_size: Vector2 = Vector2(48, 96)
var facing: int = 1
var flash: float = 0.0
var is_dead: bool = false
var is_blocking: bool = false
var in_domain: bool = false

func setup(stats: CharacterStats) -> void:
	if stats:
		body_color = stats.body_color
		accent_color = stats.accent_color
		body_size = Vector2(stats.body_width, stats.body_height)
	queue_redraw()

func set_facing(f: int) -> void:
	facing = f
	queue_redraw()

func set_flash(amount: float) -> void:
	flash = amount
	queue_redraw()

func set_dead(v: bool) -> void:
	is_dead = v
	queue_redraw()

func set_blocking(v: bool) -> void:
	is_blocking = v
	queue_redraw()

func set_domain(v: bool) -> void:
	if in_domain == v:
		return
	in_domain = v
	queue_redraw()

func _process(delta: float) -> void:
	if flash > 0.0:
		flash = maxf(0.0, flash - delta * 4.0)
		queue_redraw()
	if in_domain:
		queue_redraw()

func _draw() -> void:
	var w := body_size.x
	var h := body_size.y
	var top := -h
	var col := body_color
	if flash > 0.0:
		col = col.lerp(Color.WHITE, flash)
	if is_dead:
		col = col.darkened(0.55)
	if in_domain:
		col = col.lerp(Color(0.55, 0.2, 0.7), 0.35)

	# Domain aura
	if in_domain:
		draw_circle(Vector2(0, -h * 0.45), h * 0.72, Color(0.45, 0.1, 0.55, 0.18))
		draw_arc(Vector2(0, -h * 0.45), h * 0.72, 0, TAU, 32, Color(0.7, 0.3, 0.85, 0.55), 2.0)

	# Body
	draw_rect(Rect2(-w * 0.5, top, w, h), col)
	# Head
	draw_circle(Vector2(0, top + 10), 12.0, accent_color if flash < 0.5 else Color.WHITE)
	# Eye indicator (facing) — 鬼眼
	var eye_x := 4.0 * facing
	var eye_col := Color(0.85, 0.1, 0.15)
	if in_domain:
		eye_col = Color(1.0, 0.25, 0.9)
	draw_circle(Vector2(eye_x, top + 9), 3.5 if in_domain else 3.0, eye_col)
	# Block shield
	if is_blocking:
		draw_arc(Vector2(facing * 18, top + h * 0.45), 22.0, -PI * 0.6, PI * 0.6, 16, Color(0.6, 0.8, 1.0, 0.7), 3.0)
	# Ground shadow hint
	draw_rect(Rect2(-w * 0.4, -4, w * 0.8, 4), Color(0, 0, 0, 0.25))
