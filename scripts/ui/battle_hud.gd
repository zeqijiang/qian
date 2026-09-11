class_name BattleHUD
extends CanvasLayer
## Top battle UI: HP / Spirit / Revival / Combo / Timer.

@onready var p1_name: Label = $Root/P1Box/P1Name
@onready var p1_hp: ProgressBar = $Root/P1Box/P1HP
@onready var p1_spirit: ProgressBar = $Root/P1Box/P1Spirit
@onready var p1_revival: ProgressBar = $Root/P1Box/P1Revival
@onready var p2_name: Label = $Root/P2Box/P2Name
@onready var p2_hp: ProgressBar = $Root/P2Box/P2HP
@onready var p2_spirit: ProgressBar = $Root/P2Box/P2Spirit
@onready var p2_revival: ProgressBar = $Root/P2Box/P2Revival
@onready var timer_label: Label = $Root/TimerLabel
@onready var combo_label: Label = $Root/ComboLabel
@onready var mode_label: Label = $Root/ModeLabel
@onready var result_label: Label = $Root/ResultLabel
@onready var hint_label: Label = $Root/HintLabel
@onready var debug_label: Label = $Root/DebugLabel

var _player: Character
var _enemy: Character
var _battle_time: float = 99.0
var _time_left: float = 99.0
var _running: bool = false
var _skill_rows: Array[Dictionary] = []
var _revival_warn_t: float = 0.0

func bind(player: Character, enemy: Character) -> void:
	_player = player
	_enemy = enemy
	if _player:
		p1_name.text = _player.stats.display_name
		_player.hp_changed.connect(func(c, m): p1_hp.max_value = m; p1_hp.value = c)
		p1_hp.max_value = _player.max_hp
		p1_hp.value = _player.hp
		if _player.energy:
			_player.energy.spirit_changed.connect(func(c, m): p1_spirit.max_value = m; p1_spirit.value = c)
			_player.energy.revival_changed.connect(func(c, m): p1_revival.max_value = m; p1_revival.value = c)
			p1_spirit.max_value = _player.energy.max_spirit
			p1_spirit.value = _player.energy.spirit
			p1_revival.max_value = _player.energy.max_revival
			p1_revival.value = _player.energy.revival
		if _player.combat and _player.combat.combo:
			_player.combat.combo.combo_updated.connect(_on_p1_combo)
		_build_skill_bar(_player)
	if _enemy:
		p2_name.text = _enemy.stats.display_name
		_enemy.hp_changed.connect(func(c, m): p2_hp.max_value = m; p2_hp.value = c)
		p2_hp.max_value = _enemy.max_hp
		p2_hp.value = _enemy.hp
		if _enemy.energy:
			_enemy.energy.spirit_changed.connect(func(c, m): p2_spirit.max_value = m; p2_spirit.value = c)
			_enemy.energy.revival_changed.connect(func(c, m): p2_revival.max_value = m; p2_revival.value = c)
			p2_spirit.max_value = _enemy.energy.max_spirit
			p2_spirit.value = _enemy.energy.spirit
			p2_revival.max_value = _enemy.energy.max_revival
			p2_revival.value = _enemy.energy.revival

func _build_skill_bar(player: Character) -> void:
	if player.skills == null:
		return
	var root := $Root
	var box := HBoxContainer.new()
	box.name = "SkillBar"
	box.position = Vector2(24, 130)
	box.add_theme_constant_override("separation", 8)
	root.add_child(box)
	var order := [
		["gui_shou", "U"],
		["gui_ying", "I"],
		["gui_yu", "O"],
		["gui_yan", "H"],
		["ultimate", "P"],
	]
	for pair in order:
		var id: String = pair[0]
		var key: String = pair[1]
		if not player.skills.skills.has(id):
			continue
		var data: SkillData = player.skills.skills[id]
		var panel := PanelContainer.new()
		panel.custom_minimum_size = Vector2(78, 44)
		var style := StyleBoxFlat.new()
		style.bg_color = Color(0.12, 0.1, 0.16, 0.85)
		style.border_color = Color(0.45, 0.25, 0.55)
		style.set_border_width_all(1)
		style.set_corner_radius_all(4)
		panel.add_theme_stylebox_override("panel", style)
		var v := VBoxContainer.new()
		v.add_theme_constant_override("separation", 2)
		var name_l := Label.new()
		name_l.text = "%s [%s]" % [data.display_name, key]
		name_l.add_theme_font_size_override("font_size", 11)
		name_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		var cd := ProgressBar.new()
		cd.custom_minimum_size = Vector2(70, 6)
		cd.max_value = 1.0
		cd.value = 0.0
		cd.show_percentage = false
		v.add_child(name_l)
		v.add_child(cd)
		panel.add_child(v)
		box.add_child(panel)
		_skill_rows.append({"id": id, "bar": cd, "panel": panel, "data": data})

func start_timer(seconds: float) -> void:
	_battle_time = seconds
	_time_left = seconds
	_running = true

func stop_timer() -> void:
	_running = false

func set_mode_text(t: String) -> void:
	mode_label.text = t

func set_result(t: String) -> void:
	result_label.text = t
	result_label.visible = t != ""

func set_hints(t: String) -> void:
	hint_label.text = t

func _on_p1_combo(count: int, damage: float) -> void:
	if count >= 2:
		combo_label.text = "%d HIT  (%d DMG)" % [count, int(damage)]
		combo_label.visible = true
	else:
		combo_label.visible = false

func _process(delta: float) -> void:
	if _running:
		_time_left = maxf(0.0, _time_left - delta)
		timer_label.text = str(int(ceil(_time_left)))
	_update_skill_bars()
	_update_revival_danger(delta)
	_update_debug()

func _update_skill_bars() -> void:
	if _player == null or _player.skills == null:
		return
	for row in _skill_rows:
		var id: String = row["id"]
		var bar: ProgressBar = row["bar"]
		var panel: PanelContainer = row["panel"]
		var data: SkillData = row["data"]
		var ratio := _player.skills.get_cooldown_ratio(id)
		bar.value = 1.0 - ratio
		var affordable := true
		if _player.energy and not Debug.infinite_energy:
			affordable = _player.energy.spirit >= data.spirit_cost
		if ratio > 0.0:
			panel.modulate = Color(0.55, 0.55, 0.6)
		elif not affordable:
			panel.modulate = Color(0.7, 0.55, 0.55)
		else:
			panel.modulate = Color(1, 1, 1)

func _update_revival_danger(delta: float) -> void:
	_revival_warn_t += delta
	var pulse := (sin(_revival_warn_t * 8.0) * 0.5 + 0.5)
	if _player and _player.energy and _player.energy.revival_active:
		p1_revival.modulate = Color(1.0, 0.35 + pulse * 0.4, 0.35)
	else:
		p1_revival.modulate = Color(1, 1, 1)
	if _enemy and _enemy.energy and _enemy.energy.revival_active:
		p2_revival.modulate = Color(1.0, 0.35 + pulse * 0.4, 0.35)
	else:
		p2_revival.modulate = Color(1, 1, 1)
	if _player and _player.domain_active:
		p1_spirit.modulate = Color(0.85, 0.55, 1.0)
	else:
		p1_spirit.modulate = Color(1, 1, 1)

func _update_debug() -> void:
	if not Debug.show_state and not Debug.show_fps:
		debug_label.visible = false
		return
	debug_label.visible = true
	var parts: PackedStringArray = []
	if Debug.show_fps:
		parts.append("FPS %d" % Engine.get_frames_per_second())
	if Debug.show_state and _player:
		parts.append(_player.get_debug_text().replace("\n", " | "))
	if _enemy:
		parts.append("E:" + _enemy.get_state_name())
	if Debug.invincible:
		parts.append("INVINCIBLE")
	if Debug.infinite_energy:
		parts.append("INF_ENERGY")
	if Debug.show_hitbox:
		parts.append("HITBOX")
	if Debug.show_hurtbox:
		parts.append("HURTBOX")
	debug_label.text = "  ·  ".join(parts)
