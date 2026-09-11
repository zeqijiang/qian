extends Node
## Combat feel / presentation layer (autoload: CombatFX).
## Hitstop, camera shake, slash arcs, sparks, skill banners, domain overlay.

var _cam: Camera2D
var _shake: float = 0.0
var _shake_decay: float = 12.0
var _hitstop_left: float = 0.0
var _fx_root: Node2D
var _ui_layer: CanvasLayer
var _domain_overlay: ColorRect
var _banner: Label
var _banner_sub: Label
var _banner_t: float = 0.0

var _sfx_light: Array[AudioStream] = []
var _sfx_heavy: Array[AudioStream] = []
var _sfx_players: Array[AudioStreamPlayer2D] = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load_sfx()
	_build_ui()

func _load_sfx() -> void:
	var light := [
		"res://assets/audio/impactPunch_medium_000.ogg",
		"res://assets/audio/impactPunch_medium_001.ogg",
		"res://assets/audio/impactPunch_medium_002.ogg",
	]
	var heavy := [
		"res://assets/audio/impactPunch_heavy_000.ogg",
		"res://assets/audio/impactPunch_heavy_001.ogg",
		"res://assets/audio/impactPlate_heavy_000.ogg",
		"res://assets/audio/impactBell_heavy_000.ogg",
	]
	for p in light:
		if ResourceLoader.exists(p):
			_sfx_light.append(load(p))
	for p in heavy:
		if ResourceLoader.exists(p):
			_sfx_heavy.append(load(p))
	for i in 6:
		var pl := AudioStreamPlayer2D.new()
		pl.bus = "Master"
		add_child(pl)
		_sfx_players.append(pl)

func _build_ui() -> void:
	_ui_layer = CanvasLayer.new()
	_ui_layer.layer = 20
	add_child(_ui_layer)

	_domain_overlay = ColorRect.new()
	_domain_overlay.color = Color(0.35, 0.05, 0.45, 0.0)
	_domain_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_domain_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_domain_overlay.visible = false
	_ui_layer.add_child(_domain_overlay)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_ui_layer.add_child(center)

	var box := VBoxContainer.new()
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	center.add_child(box)

	_banner = Label.new()
	_banner.text = ""
	_banner.add_theme_font_size_override("font_size", 42)
	_banner.add_theme_color_override("font_color", Color(1, 0.92, 0.55))
	_banner.add_theme_color_override("font_outline_color", Color(0.1, 0, 0.1, 0.9))
	_banner.add_theme_constant_override("outline_size", 6)
	_banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(_banner)

	_banner_sub = Label.new()
	_banner_sub.text = ""
	_banner_sub.add_theme_font_size_override("font_size", 18)
	_banner_sub.add_theme_color_override("font_color", Color(0.9, 0.75, 1))
	_banner_sub.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8))
	_banner_sub.add_theme_constant_override("outline_size", 3)
	_banner_sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(_banner_sub)

func bind_camera(cam: Camera2D) -> void:
	_cam = cam

func ensure_fx_root(parent: Node) -> void:
	if parent == null:
		return
	if _fx_root and is_instance_valid(_fx_root):
		return
	_fx_root = Node2D.new()
	_fx_root.name = "CombatFXRoot"
	_fx_root.z_index = 40
	parent.add_child(_fx_root)

func _process(_delta: float) -> void:
	# Unscaled so hitstop recovery is correct when Engine.time_scale is low.
	var udelta := 1.0 / 60.0
	if Engine.time_scale > 0.0001:
		udelta = minf(get_process_delta_time() / Engine.time_scale, 0.05)
	if _hitstop_left > 0.0:
		_hitstop_left -= udelta
		if _hitstop_left <= 0.0:
			Engine.time_scale = 1.0
	if _shake > 0.0 and _cam:
		_shake = maxf(0.0, _shake - _shake_decay * udelta)
		_cam.offset = Vector2(
			randf_range(-_shake, _shake),
			randf_range(-_shake, _shake)
		)
	elif _cam:
		_cam.offset = _cam.offset.lerp(Vector2.ZERO, 20.0 * udelta)
	if _banner_t > 0.0:
		_banner_t -= udelta
		if _banner_t <= 0.0:
			_banner.text = ""
			_banner_sub.text = ""
			_banner.modulate.a = 1.0

func hitstop(duration: float, time_scale: float = 0.05) -> void:
	if duration <= 0.0:
		return
	_hitstop_left = maxf(_hitstop_left, duration)
	Engine.time_scale = time_scale

func shake(amount: float) -> void:
	_shake = maxf(_shake, amount)

func play_hit_sfx(at: Vector2, heavy: bool = false) -> void:
	var pool := _sfx_heavy if heavy else _sfx_light
	if pool.is_empty():
		return
	var stream: AudioStream = pool[randi_range(0, pool.size() - 1)]
	for pl in _sfx_players:
		if not pl.playing:
			pl.global_position = at
			pl.stream = stream
			pl.pitch_scale = randf_range(0.92, 1.08)
			pl.play()
			return

func show_skill_banner(title: String, sub: String = "", duration: float = 0.85) -> void:
	_banner.text = title
	_banner_sub.text = sub
	_banner.modulate = Color(1, 1, 1, 1)
	var tw := create_tween()
	tw.tween_property(_banner, "scale", Vector2(1.15, 1.15), 0.08)
	tw.tween_property(_banner, "scale", Vector2.ONE, 0.12)
	_banner_t = duration

func set_domain_active(active: bool, color: Color = Color(0.4, 0.08, 0.55, 0.22)) -> void:
	_domain_overlay.visible = active
	if active:
		_domain_overlay.color = color
		var tw := create_tween()
		_domain_overlay.color.a = 0.0
		tw.tween_property(_domain_overlay, "color:a", color.a, 0.15)
	else:
		var tw := create_tween()
		tw.tween_property(_domain_overlay, "color:a", 0.0, 0.25)
		tw.tween_callback(func() -> void: _domain_overlay.visible = false)

func slash_arc(at: Vector2, facing: int, color: Color, size: float = 70.0, angle: float = -0.6) -> void:
	if _fx_root == null or not is_instance_valid(_fx_root):
		return
	var n := Node2D.new()
	n.position = at
	n.z_index = 45
	_fx_root.add_child(n)
	var poly := Line2D.new()
	poly.width = 5.0
	poly.default_color = color
	poly.joint_mode = Line2D.LINE_JOINT_ROUND
	# Crescent slash points
	var pts := PackedVector2Array()
	var base_rot := angle if facing >= 0 else PI - angle
	for i in 9:
		var t := float(i) / 8.0
		var a := base_rot + lerpf(-0.9, 0.9, t)
		var r := size * (0.75 + 0.25 * sin(t * PI))
		pts.append(Vector2(cos(a), sin(a)) * r * float(facing))
	poly.points = pts
	n.add_child(poly)
	# Glow line
	var glow := Line2D.new()
	glow.width = 12.0
	glow.default_color = Color(color.r, color.g, color.b, 0.35)
	glow.points = pts
	n.add_child(glow)
	var tw := n.create_tween()
	tw.set_parallel(true)
	tw.tween_property(poly, "modulate:a", 0.0, 0.18)
	tw.tween_property(glow, "modulate:a", 0.0, 0.22)
	tw.tween_property(n, "scale", Vector2(1.25, 1.25), 0.2)
	tw.chain().tween_callback(n.queue_free)

func hit_spark(at: Vector2, color: Color, count: int = 10, power: float = 1.0) -> void:
	if _fx_root == null or not is_instance_valid(_fx_root):
		return
	var n := Node2D.new()
	n.position = at
	n.z_index = 46
	_fx_root.add_child(n)
	for i in count:
		var a := TAU * float(i) / float(count) + randf_range(-0.2, 0.2)
		var speed := randf_range(120.0, 320.0) * power
		var line := Line2D.new()
		line.width = randf_range(2.0, 4.0)
		line.default_color = Color(color.lightened(0.3), 1.0)
		var dir := Vector2(cos(a), sin(a))
		line.points = PackedVector2Array([dir * 6.0, dir * (18.0 + speed * 0.04)])
		n.add_child(line)
		var tw := line.create_tween()
		tw.set_parallel(true)
		tw.tween_property(line, "position", dir * speed * 0.08, 0.16)
		tw.tween_property(line, "modulate:a", 0.0, 0.16)
		tw.chain().tween_callback(line.queue_free)
	var ring := Line2D.new()
	ring.width = 3.0
	ring.default_color = Color(1, 1, 1, 0.8)
	var ring_pts := PackedVector2Array()
	for i in 17:
		var a := TAU * float(i) / 16.0
		ring_pts.append(Vector2(cos(a), sin(a)) * 8.0)
	ring.points = ring_pts
	n.add_child(ring)
	var tw2 := n.create_tween()
	tw2.set_parallel(true)
	tw2.tween_property(ring, "scale", Vector2(3.2, 3.2), 0.2)
	tw2.tween_property(n, "modulate:a", 0.0, 0.22)
	tw2.chain().tween_callback(n.queue_free)

func afterimage(char: Node2D, color: Color, life: float = 0.22) -> void:
	if char == null or _fx_root == null or not is_instance_valid(_fx_root):
		return
	var ghost := Node2D.new()
	ghost.position = char.global_position
	ghost.z_index = 30
	_fx_root.add_child(ghost)
	var rect := ColorRect.new()
	var w := 48.0
	var h := 96.0
	if char.get("stats") and char.stats:
		w = char.stats.body_width
		h = char.stats.body_height
	rect.size = Vector2(w, h)
	rect.position = Vector2(-w * 0.5, -h)
	rect.color = Color(color, 0.45)
	ghost.add_child(rect)
	var tw := ghost.create_tween()
	tw.tween_property(rect, "color:a", 0.0, life)
	tw.tween_callback(ghost.queue_free)

func cast_flash(char: Node2D, color: Color) -> void:
	if char == null:
		return
	var at: Vector2 = char.global_position + Vector2(0, -50)
	hit_spark(at, color, 14, 0.7)
	slash_arc(at, int(char.get("facing") if char.get("facing") != null else 1), color, 90.0, -1.2)

func notify_skill_cast(character: Character, skill_id: String, display_name: String) -> void:
	if character == null:
		return
	var col := Color(0.75, 0.35, 1.0)
	if character.stats:
		col = character.stats.body_color.lightened(0.35)
	match skill_id:
		"gui_yu":
			show_skill_banner("鬼 域", "领域展开", 1.0)
			set_domain_active(true, Color(0.45, 0.08, 0.6, 0.28))
			cast_flash(character, Color(0.8, 0.3, 1.0))
			shake(6.0)
			hitstop(0.08, 0.2)
		"ultimate":
			show_skill_banner(display_name if display_name != "" else "奥 义", "ULTIMATE", 1.2)
			cast_flash(character, Color(1, 0.85, 0.3))
			shake(12.0)
			hitstop(0.14, 0.12)
		"gui_shou", "gui_ying", "gui_yan", "tie_chong", "beng_quan", "tie_bi", "ba_ti", "burst", "shove":
			show_skill_banner(display_name, skill_id, 0.55)
			cast_flash(character, col)
			shake(3.5)
			hitstop(0.04, 0.2)
		_:
			cast_flash(character, col)

func notify_hit(attacker: Character, victim: Character, info: DamageInfo, damage: float) -> void:
	if victim == null:
		return
	var at: Vector2 = victim.global_position + Vector2(randf_range(-8, 8), -55)
	var heavy := damage >= 45.0 or (info and info.launch)
	var col := Color(1.0, 0.85, 0.35) if heavy else Color(1.0, 0.45, 0.4)
	if attacker and attacker.stats:
		col = attacker.stats.accent_color.lerp(Color.WHITE, 0.35)
	hit_spark(at, col, 14 if heavy else 8, 1.2 if heavy else 0.8)
	slash_arc(at, attacker.facing if attacker else 1, col, 64.0 if not heavy else 88.0)
	play_hit_sfx(at, heavy)
	shake(4.0 if not heavy else 8.0)
	hitstop(0.04 if not heavy else 0.07, 0.12)
	if attacker:
		afterimage(attacker, attacker.stats.body_color if attacker.stats else Color.CYAN, 0.16)

func notify_dash(character: Character) -> void:
	if character == null:
		return
	var col := Color(0.5, 0.8, 1.0)
	if character.stats:
		col = character.stats.body_color
	afterimage(character, col, 0.2)

func notify_domain_end() -> void:
	set_domain_active(false)
