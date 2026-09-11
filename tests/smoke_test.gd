extends SceneTree
## Headless smoke test. Run:
##   godot --headless --path . --script res://tests/smoke_test.gd
## Only tests modules that do not depend on autoload globals.

var _fails: Array[String] = []

func _init() -> void:
	_run()

func _run() -> void:
	print("=== SMOKE TEST START ===")
	_test_stats()
	_test_damage_formula()
	_test_combo()
	_test_game_constants()
	_test_yangjian_kit()
	_test_ye_zhen_kit()
	_test_registry()
	if _fails.is_empty():
		print("=== ALL PASSED ===")
		quit(0)
	else:
		print("=== FAILED (%d) ===" % _fails.size())
		for f in _fails:
			print("FAIL: ", f)
		quit(1)

func _ok(cond: bool, msg: String) -> void:
	if cond:
		print("OK: ", msg)
	else:
		_fails.append(msg)
		print("ERR: ", msg)

func _test_stats() -> void:
	var s := CharacterStats.new()
	s.max_hp = 1000.0
	_ok(s.max_hp == 1000.0, "stats max_hp")
	var c := s.clone()
	c.max_hp = 500.0
	_ok(s.max_hp == 1000.0, "clone does not mutate source")

func _test_damage_formula() -> void:
	var d := DamageInfo.new()
	d.base_damage = 50.0
	d.skill_multiplier = 2.0
	_ok(is_equal_approx(d.compute_damage(0.5, 1.0), 50.0), "damage formula basic")
	_ok(is_equal_approx(d.compute_damage(1.0, 1.0), 100.0), "damage formula multiplier")

func _test_combo() -> void:
	var cm := ComboManager.new()
	cm.combo_window = 999.0
	cm.register_hit("light", 20.0)
	cm.register_hit("light", 20.0)
	cm.register_hit("heavy", 50.0)
	_ok(cm.combo_count == 3, "combo count 3")
	_ok(is_equal_approx(cm.combo_damage, 90.0), "combo damage 90")
	cm.drop_combo()
	_ok(cm.combo_count == 0, "combo drop")

func _test_game_constants() -> void:
	_ok(GameConstants.MAX_SPIRIT == 100.0, "max spirit")
	_ok(GameConstants.REVIVAL_THRESHOLD == 80.0, "revival threshold")
	_ok(GameConstants.LAYER_HITBOX == 8, "hitbox layer mask")
	_ok(GameConstants.LAYER_HURTBOX == 16, "hurtbox layer mask")

func _test_yangjian_kit() -> void:
	var skills := YangJianKit.build_skills()
	_ok(skills.size() == 5, "yangjian has 5 skills")
	var ids: Array[String] = []
	for s in skills:
		ids.append(s.skill_id)
		var p := s.to_profile()
		_ok(p.has("spirit_cost") and p.has("effect_type"), "profile keys for " + s.skill_id)
	_ok("gui_shou" in ids, "has gui_shou")
	_ok("gui_ying" in ids, "has gui_ying")
	_ok("gui_yu" in ids, "has gui_yu")
	_ok("gui_yan" in ids, "has gui_yan")
	_ok("ultimate" in ids, "has ultimate")
	for s in skills:
		if s.skill_id == "ultimate":
			_ok(is_equal_approx(s.spirit_cost, 100.0), "ultimate costs full spirit")
		if s.skill_id == "gui_yu":
			_ok(s.effect_type == SkillData.EffectType.DOMAIN, "gui_yu is domain")

func _test_ye_zhen_kit() -> void:
	var skills := YeZhenKit.build_skills()
	_ok(skills.size() == 5, "ye zhen has 5 skills")
	var ids: Array[String] = []
	for s in skills:
		ids.append(s.skill_id)
	_ok("tie_chong" in ids, "has tie_chong")
	_ok("beng_quan" in ids, "has beng_quan")
	_ok("tie_bi" in ids, "has tie_bi")
	_ok("ba_ti" in ids, "has ba_ti")
	_ok("ultimate" in ids, "has ultimate")
	for s in skills:
		if s.skill_id == "ultimate":
			_ok(is_equal_approx(s.spirit_cost, 100.0), "ye zhen ultimate cost")

func _test_registry() -> void:
	_ok(CharacterRegistry.playable_ids().size() == 2, "two playable fighters")
	var yj := CharacterRegistry.build_stats("yangjian")
	var yz := CharacterRegistry.build_stats("ye_zhen")
	_ok(yz.max_hp > yj.max_hp, "ye zhen tankier")
	_ok(yz.move_speed < yj.move_speed, "ye zhen slower")
	_ok(yz.attack > yj.attack, "ye zhen stronger")
	_ok(CharacterRegistry.display_name("ye_zhen") == "叶真", "ye zhen display name")
