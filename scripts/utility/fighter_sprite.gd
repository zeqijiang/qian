class_name FighterSprite
extends Node2D
## Character art with lightweight procedural animation (no frame sheets).

var texture: Texture2D
var body_color: Color = Color(0.25, 0.45, 0.95)
var facing: int = 1
var flash: float = 0.0
var is_dead: bool = false
var is_blocking: bool = false
var in_domain: bool = false

var _sprite: Sprite2D
var _bob_t: float = 0.0
var _punch: float = 0.0
var _lean: float = 0.0
var _base_scale: Vector2 = Vector2.ONE

func setup(stats: CharacterStats) -> void:
	if stats:
		body_color = stats.body_color
		var path := sprite_path_for(stats.character_name)
		if path != "" and ResourceLoader.exists(path):
			texture = load(path)
	if _sprite == null:
		_sprite = Sprite2D.new()
		_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		add_child(_sprite)
	_sprite.texture = texture
	if texture:
		# Fit ~160px tall battle size
		var h := 160.0
		var s := h / float(texture.get_height())
		_base_scale = Vector2(s, s)
		_sprite.scale = _base_scale
		_sprite.position = Vector2(0, -h * 0.5)
	else:
		_setup_fallback_rect()
	queue_redraw()

static func sprite_path_for(character_name: String) -> String:
	match character_name:
		"yangjian":
			return "res://assets/sprites/yangjian.png"
		"ye_zhen":
			return "res://assets/sprites/ye_zhen.png"
		"zhang_xianguang":
			return "res://assets/sprites/zhang_xianguang.png"
		"li_leping":
			return "res://assets/sprites/li_leping.png"
		"captain":
			return "res://assets/sprites/captain.png"
	return ""

func _setup_fallback_rect() -> void:
	if _sprite:
		_sprite.visible = false
	var rect := ColorRect.new()
	rect.size = Vector2(48, 96)
	rect.position = Vector2(-24, -96)
	rect.color = body_color
	add_child(rect)

func set_facing(f: int) -> void:
	facing = f
	queue_redraw()

func set_flash(amount: float) -> void:
	flash = amount

func set_dead(v: bool) -> void:
	is_dead = v
	queue_redraw()

func set_blocking(v: bool) -> void:
	is_blocking = v

func set_domain(v: bool) -> void:
	if in_domain == v:
		return
	in_domain = v
	queue_redraw()

func play_attack_punch(strength: float = 1.0) -> void:
	_punch = maxf(_punch, strength)

func play_lean(dir: float) -> void:
	_lean = dir

func _process(delta: float) -> void:
	_bob_t += delta
	if flash > 0.0:
		flash = maxf(0.0, flash - delta * 4.5)
	if _punch > 0.0:
		_punch = maxf(0.0, _punch - delta * 6.0)
	_lean = lerpf(_lean, 0.0, delta * 8.0)
	_update_sprite(delta)

func _update_sprite(delta: float) -> void:
	if _sprite == null or texture == null:
		return
	var bob := sin(_bob_t * 4.5) * 2.0
	# Source art faces LEFT by default — flip when facing right (facing=+1).
	var sx := _base_scale.x * -float(facing)
	var sy := _base_scale.y
	# Attack punch: stretch forward
	if _punch > 0.0:
		sx *= 1.0 + _punch * 0.18
		sy *= 1.0 - _punch * 0.08
	# Walk lean
	sx *= 1.0 + _lean * 0.06
	_sprite.scale = Vector2(sx, sy)
	_sprite.position = Vector2(_lean * 6.0 * float(facing), -160.0 * 0.5 + bob)
	_sprite.rotation = _lean * 0.12 * float(facing)
	if is_dead:
		_sprite.rotation = 1.2 * float(facing)
		_sprite.position.y += 20.0
		_sprite.modulate = Color(0.55, 0.55, 0.6, 0.85)
	else:
		var col := Color.WHITE
		if flash > 0.0:
			col = Color.WHITE.lerp(Color(1, 0.75, 0.75), flash)
		if in_domain:
			col = col.lerp(Color(0.85, 0.55, 1.0), 0.25)
		if is_blocking:
			col = col.lerp(Color(0.7, 0.85, 1.0), 0.2)
		_sprite.modulate = col

func _draw() -> void:
	if in_domain:
		draw_circle(Vector2(0, -80), 70.0, Color(0.45, 0.1, 0.55, 0.16))
		draw_arc(Vector2(0, -80), 70.0, 0, TAU, 36, Color(0.75, 0.3, 0.9, 0.5), 2.0)
	# Ground shadow
	draw_ellipse_shadow()

func draw_ellipse_shadow() -> void:
	var pts := PackedVector2Array()
	for i in 17:
		var a := TAU * float(i) / 16.0
		pts.append(Vector2(cos(a) * 28.0, sin(a) * 6.0))
	draw_colored_polygon(pts, Color(0, 0, 0, 0.28))
