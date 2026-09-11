class_name CharacterRegistry
extends RefCounted
## Roster lookup for menu + battle spawn.

const IDs := ["yangjian", "ye_zhen", "zhang_xianguang", "li_leping", "captain", "placeholder_enemy"]

static func display_name(id: String) -> String:
	match id:
		"yangjian":
			return "杨间"
		"ye_zhen":
			return "叶真"
		"zhang_xianguang":
			return "张羡光"
		"li_leping":
			return "李乐平"
		"captain":
			return "船长"
		"placeholder_enemy":
			return "占位敌人"
	return id

static func blurb(id: String) -> String:
	match id:
		"yangjian":
			return "综合 · 鬼域控制 · 高机动"
		"ye_zhen":
			return "近战 · 高防 · 霸体爆发"
		"zhang_xianguang":
			return "机动 · 影遁分身 · 鬼教室"
		"li_leping":
			return "暗杀 · 标记 · 鬼烟隐身"
		"captain":
			return "反派 · 登船规则 · 海水冲刷 · 厉鬼潮"
		"placeholder_enemy":
			return "测试用灵异木偶"
	return ""

static func color(id: String) -> Color:
	match id:
		"yangjian":
			return Color(0.2, 0.42, 0.92)
		"ye_zhen":
			return Color(0.92, 0.55, 0.12)
		"zhang_xianguang":
			return Color(0.15, 0.15, 0.18)
		"li_leping":
			return Color(0.45, 0.2, 0.7)
		"captain":
			return Color(0.12, 0.28, 0.35)
		"placeholder_enemy":
			return Color(0.85, 0.22, 0.28)
	return Color.GRAY

static func sprite_path(id: String) -> String:
	match id:
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

static func load_sprite(id: String) -> Texture2D:
	var p := sprite_path(id)
	if p != "" and ResourceLoader.exists(p):
		return load(p)
	return null

static func playable_ids() -> Array[String]:
	return ["yangjian", "ye_zhen", "zhang_xianguang", "li_leping", "captain"]

static func villain_id() -> String:
	return "captain"

static func build_stats(id: String) -> CharacterStats:
	match id:
		"yangjian":
			return _yangjian()
		"ye_zhen":
			return _ye_zhen()
		"zhang_xianguang":
			return _zhang()
		"li_leping":
			return _li()
		"captain":
			return _captain()
		_:
			return _placeholder()

static func _yangjian() -> CharacterStats:
	var s := CharacterStats.new()
	s.character_name = "yangjian"
	s.display_name = "杨间"
	s.max_hp = 1000.0
	s.attack = 1.05
	s.defense = 1.0
	s.move_speed = 300.0
	s.jump_velocity = -640.0
	s.dash_speed = 560.0
	s.dash_duration = 0.18
	s.air_control = 0.7
	s.max_spirit = 100.0
	s.max_revival = 100.0
	s.spirit_gain_on_hit = 9.0
	s.spirit_gain_on_hurt = 5.5
	s.revival_gain_on_cast = 6.0
	s.revival_gain_on_hurt = 3.5
	s.revival_passive_rate = 0.9
	s.body_color = Color(0.2, 0.42, 0.92)
	s.accent_color = Color(0.85, 0.92, 1)
	s.body_width = 48.0
	s.body_height = 96.0
	return s

static func _ye_zhen() -> CharacterStats:
	var s := CharacterStats.new()
	s.character_name = "ye_zhen"
	s.display_name = "叶真"
	s.max_hp = 1150.0
	s.attack = 1.15
	s.defense = 1.2
	s.move_speed = 250.0
	s.jump_velocity = -600.0
	s.dash_speed = 480.0
	s.dash_duration = 0.16
	s.air_control = 0.5
	s.max_spirit = 100.0
	s.max_revival = 100.0
	s.spirit_gain_on_hit = 10.0
	s.spirit_gain_on_hurt = 6.0
	s.revival_gain_on_cast = 8.0
	s.revival_gain_on_hurt = 4.0
	s.revival_passive_rate = 1.0
	s.body_color = Color(0.92, 0.55, 0.12)
	s.accent_color = Color(1, 0.9, 0.7)
	s.body_width = 56.0
	s.body_height = 100.0
	return s

static func _zhang() -> CharacterStats:
	var s := CharacterStats.new()
	s.character_name = "zhang_xianguang"
	s.display_name = "张羡光"
	s.max_hp = 980.0
	s.attack = 1.1
	s.defense = 0.95
	s.move_speed = 320.0
	s.jump_velocity = -650.0
	s.dash_speed = 600.0
	s.dash_duration = 0.17
	s.air_control = 0.75
	s.max_spirit = 100.0
	s.max_revival = 100.0
	s.spirit_gain_on_hit = 8.0
	s.spirit_gain_on_hurt = 5.0
	s.revival_gain_on_cast = 7.0
	s.revival_gain_on_hurt = 3.0
	s.revival_passive_rate = 0.85
	s.body_color = Color(0.18, 0.18, 0.22)
	s.accent_color = Color(0.95, 0.85, 0.35)
	s.body_width = 52.0
	s.body_height = 100.0
	return s

static func _li() -> CharacterStats:
	var s := CharacterStats.new()
	s.character_name = "li_leping"
	s.display_name = "李乐平"
	s.max_hp = 950.0
	s.attack = 1.12
	s.defense = 0.9
	s.move_speed = 310.0
	s.jump_velocity = -630.0
	s.dash_speed = 580.0
	s.dash_duration = 0.16
	s.air_control = 0.7
	s.max_spirit = 100.0
	s.max_revival = 100.0
	s.spirit_gain_on_hit = 8.5
	s.spirit_gain_on_hurt = 5.0
	s.revival_gain_on_cast = 7.5
	s.revival_gain_on_hurt = 3.2
	s.revival_passive_rate = 0.9
	s.body_color = Color(0.35, 0.18, 0.55)
	s.accent_color = Color(0.75, 0.55, 1.0)
	s.body_width = 50.0
	s.body_height = 98.0
	return s

static func _captain() -> CharacterStats:
	var s := CharacterStats.new()
	s.character_name = "captain"
	s.display_name = "船长"
	s.max_hp = 1200.0
	s.attack = 1.08
	s.defense = 1.15
	s.move_speed = 270.0
	s.jump_velocity = -600.0
	s.dash_speed = 500.0
	s.dash_duration = 0.18
	s.air_control = 0.55
	s.max_spirit = 100.0
	s.max_revival = 100.0
	s.spirit_gain_on_hit = 9.0
	s.spirit_gain_on_hurt = 6.0
	s.revival_gain_on_cast = 7.0
	s.revival_gain_on_hurt = 3.5
	s.revival_passive_rate = 0.9
	s.body_color = Color(0.12, 0.28, 0.35)
	s.accent_color = Color(0.35, 0.75, 0.85)
	s.body_width = 60.0
	s.body_height = 108.0
	return s

static func _placeholder() -> CharacterStats:
	var s := CharacterStats.new()
	s.character_name = "placeholder_enemy"
	s.display_name = "占位敌人"
	s.max_hp = 1000.0
	s.attack = 0.95
	s.defense = 1.05
	s.move_speed = 260.0
	s.jump_velocity = -600.0
	s.dash_speed = 480.0
	s.dash_duration = 0.16
	s.air_control = 0.55
	s.max_spirit = 100.0
	s.max_revival = 100.0
	s.spirit_gain_on_hit = 7.0
	s.spirit_gain_on_hurt = 5.0
	s.revival_gain_on_cast = 5.0
	s.revival_gain_on_hurt = 2.5
	s.revival_passive_rate = 0.7
	s.body_color = Color(0.85, 0.22, 0.28)
	s.accent_color = Color(1, 0.75, 0.7)
	s.body_width = 52.0
	s.body_height = 98.0
	return s
