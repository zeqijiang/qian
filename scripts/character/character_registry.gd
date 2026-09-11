class_name CharacterRegistry
extends RefCounted
## Roster lookup for menu + battle spawn.

const IDs := ["yangjian", "ye_zhen", "placeholder_enemy"]

static func display_name(id: String) -> String:
	match id:
		"yangjian":
			return "杨间"
		"ye_zhen":
			return "叶真"
		"placeholder_enemy":
			return "占位敌人"
	return id

static func blurb(id: String) -> String:
	match id:
		"yangjian":
			return "综合 · 鬼域控制 · 高机动"
		"ye_zhen":
			return "近战 · 高防 · 霸体爆发"
		"placeholder_enemy":
			return "测试用灵异木偶"
	return ""

static func color(id: String) -> Color:
	match id:
		"yangjian":
			return Color(0.2, 0.42, 0.92)
		"ye_zhen":
			return Color(0.92, 0.55, 0.12)
		"placeholder_enemy":
			return Color(0.85, 0.22, 0.28)
	return Color.GRAY

static func sprite_path(id: String) -> String:
	match id:
		"yangjian":
			return "res://assets/sprites/yangjian.png"
		"ye_zhen":
			return "res://assets/sprites/ye_zhen.png"
	return ""

static func load_sprite(id: String) -> Texture2D:
	var p := sprite_path(id)
	if p != "" and ResourceLoader.exists(p):
		return load(p)
	return null

static func playable_ids() -> Array[String]:
	return ["yangjian", "ye_zhen"]

static func build_stats(id: String) -> CharacterStats:
	match id:
		"yangjian":
			return _yangjian()
		"ye_zhen":
			return _ye_zhen()
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
