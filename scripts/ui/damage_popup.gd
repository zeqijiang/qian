class_name DamagePopup
extends Node2D
## Floating damage number. Auto-frees.

var _label: Label
var _vel: Vector2
var _life: float = 0.0
var _max_life: float = 0.7

static func spawn(parent: Node, at: Vector2, text: String, color: Color = Color.WHITE, is_crit: bool = false) -> void:
	if parent == null:
		return
	var p := DamagePopup.new()
	p.global_position = at
	parent.add_child(p)
	p._setup(text, color, is_crit)

func _setup(text: String, color: Color, is_crit: bool) -> void:
	_label = Label.new()
	_label.text = text
	_label.modulate = color
	_label.z_index = 50
	_label.add_theme_font_size_override("font_size", 28 if is_crit else 22)
	_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	_label.add_theme_constant_override("outline_size", 4)
	_label.position = Vector2(-20, -20)
	add_child(_label)
	_vel = Vector2(randf_range(-30, 30), -140 if is_crit else -110)
	if is_crit:
		_max_life = 0.95
	scale = Vector2.ONE * (1.15 if is_crit else 1.0)

func _process(delta: float) -> void:
	_life += delta
	position += _vel * delta
	_vel.y += 220.0 * delta
	if _label:
		var t := clampf(_life / _max_life, 0.0, 1.0)
		_label.modulate.a = 1.0 - t * t
		scale = scale.lerp(Vector2.ONE * 0.85, delta * 4.0)
	if _life >= _max_life:
		queue_free()
