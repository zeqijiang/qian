class_name LiLepingKit
extends RefCounted
## 李乐平・夜游神 — stealth / mark / smoke control.

static func build_skills() -> Array[SkillData]:
	var out: Array[SkillData] = []

	# U 遗忘·擦除存在 — invuln vanish, backstab, spirit drain
	var forget := SkillData.new()
	forget.skill_id = "yi_wang"
	forget.display_name = "遗忘"
	forget.effect_type = SkillData.EffectType.DAMAGE
	forget.spirit_cost = 22.0
	forget.cooldown = 1.0
	forget.startup = 0.08
	forget.active = 0.1
	forget.recovery = 0.16
	forget.damage = 32.0
	forget.hitstun = 0.3
	forget.knockback = 80.0
	forget.reach = 90.0
	forget.revival_side_effect = 6.0
	out.append(forget)

	# I 找人鬼 — mark
	var mark := SkillData.new()
	mark.skill_id = "zhao_ren"
	mark.display_name = "找到你了"
	mark.effect_type = SkillData.EffectType.SUPPRESS
	mark.spirit_cost = 25.0
	mark.cooldown = 0.7
	mark.startup = 0.1
	mark.active = 0.08
	mark.recovery = 0.14
	mark.damage = 20.0
	mark.hitstun = 0.2
	mark.knockback = 50.0
	mark.reach = 100.0
	mark.suppress_duration = 0.25
	mark.unblockable = false
	mark.revival_side_effect = 8.0
	out.append(mark)

	# O 鬼烟 — smoke field (domain shell)
	var smoke := SkillData.new()
	smoke.skill_id = "gui_yan_smoke"
	smoke.display_name = "鬼烟"
	smoke.effect_type = SkillData.EffectType.DOMAIN
	smoke.spirit_cost = 32.0
	smoke.cooldown = 3.5
	smoke.startup = 0.16
	smoke.active = 0.0
	smoke.recovery = 0.2
	smoke.damage = 8.0
	smoke.hitstun = 0.08
	smoke.knockback = 40.0
	smoke.reach = 130.0
	smoke.domain_duration = 5.0
	smoke.domain_speed_mult = 1.1
	smoke.domain_damage_mult = 1.15
	smoke.domain_enemy_slow = 0.65
	smoke.revival_side_effect = 10.0
	out.append(smoke)

	# H 梦游重击
	var dream := SkillData.new()
	dream.skill_id = "meng_you"
	dream.display_name = "梦游重击"
	dream.effect_type = SkillData.EffectType.DAMAGE
	dream.spirit_cost = 28.0
	dream.cooldown = 1.0
	dream.startup = 0.14
	dream.active = 0.1
	dream.recovery = 0.22
	dream.damage = 62.0
	dream.hitstun = 0.38
	dream.knockback = 220.0
	dream.reach = 85.0
	dream.launch = true
	dream.launch_velocity = -420.0
	dream.revival_side_effect = 9.0
	out.append(dream)

	# Ultimate 夜游·遗忘世间
	var ult := SkillData.new()
	ult.skill_id = "ultimate"
	ult.display_name = "遗忘世间"
	ult.effect_type = SkillData.EffectType.ULTIMATE
	ult.spirit_cost = 100.0
	ult.cooldown = 8.0
	ult.startup = 0.25
	ult.active = 0.0
	ult.recovery = 0.35
	ult.damage = 26.0
	ult.hitstun = 0.15
	ult.knockback = 35.0
	ult.reach = 100.0
	ult.ultimate_hits = 4
	ult.ultimate_hit_interval = 0.16
	ult.ultimate_finisher_damage = 95.0
	ult.launch = true
	ult.launch_velocity = -480.0
	ult.domain_duration = 3.0
	ult.domain_speed_mult = 1.08
	ult.domain_damage_mult = 1.25
	ult.domain_enemy_slow = 0.75
	ult.revival_side_effect = 20.0
	out.append(ult)

	return out
