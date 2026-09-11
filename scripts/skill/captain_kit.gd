class_name CaptainKit
extends RefCounted
## 船长・幽灵船长 — summon / spirit-wash / board-and-seal control.

static func build_skills() -> Array[SkillData]:
	var out: Array[SkillData] = []

	# U 登船规则·扣押 — hook grab, drag + hold
	var hook := SkillData.new()
	hook.skill_id = "deng_chuan"
	hook.display_name = "登船扣押"
	hook.effect_type = SkillData.EffectType.SUPPRESS
	hook.spirit_cost = 22.0
	hook.cooldown = 0.7
	hook.startup = 0.12
	hook.active = 0.1
	hook.recovery = 0.18
	hook.damage = 40.0
	hook.hitstun = 0.45
	hook.knockback = -200.0  # pull toward captain
	hook.reach = 120.0
	hook.suppress_duration = 0.8
	hook.unblockable = false
	hook.revival_side_effect = 6.0
	out.append(hook)

	# I 释放厉鬼 — multi delayed spirit bites
	var spirits := SkillData.new()
	spirits.skill_id = "li_gui"
	spirits.display_name = "厉鬼潮"
	spirits.effect_type = SkillData.EffectType.GHOST_SHADOW
	spirits.spirit_cost = 28.0
	spirits.cooldown = 1.0
	spirits.startup = 0.14
	spirits.active = 0.08
	spirits.recovery = 0.2
	spirits.damage = 18.0
	spirits.hitstun = 0.14
	spirits.knockback = 60.0
	spirits.reach = 100.0
	spirits.followup_delay = 0.28
	spirits.followup_damage = 28.0
	spirits.followup_hitstun = 0.25
	spirits.followup_reach = 110.0
	spirits.followup_offset = 50.0
	spirits.revival_side_effect = 8.0
	out.append(spirits)

	# O 灵异海水·冲刷 — domain, wash spirit, slow
	var wash := SkillData.new()
	wash.skill_id = "hai_shui"
	wash.display_name = "灵异海水"
	wash.effect_type = SkillData.EffectType.DOMAIN
	wash.spirit_cost = 34.0
	wash.cooldown = 3.5
	wash.startup = 0.18
	wash.active = 0.0
	wash.recovery = 0.22
	wash.damage = 25.0
	wash.hitstun = 0.2
	wash.knockback = 140.0
	wash.reach = 140.0
	wash.domain_duration = 5.5
	wash.domain_speed_mult = 1.12
	wash.domain_damage_mult = 1.15
	wash.domain_enemy_slow = 0.6
	wash.revival_side_effect = 10.0
	out.append(wash)

	# H 弯刀浪涌
	var slash := SkillData.new()
	slash.skill_id = "lang_yong"
	slash.display_name = "浪涌重斩"
	slash.effect_type = SkillData.EffectType.DAMAGE
	slash.spirit_cost = 26.0
	slash.cooldown = 0.8
	slash.startup = 0.13
	slash.active = 0.1
	slash.recovery = 0.2
	slash.damage = 58.0
	slash.hitstun = 0.35
	slash.knockback = 230.0
	slash.reach = 95.0
	slash.launch = true
	slash.launch_velocity = -400.0
	slash.revival_side_effect = 8.0
	out.append(slash)

	# Ultimate 幽灵船降临·方舟
	var ult := SkillData.new()
	ult.skill_id = "ultimate"
	ult.display_name = "方舟降临"
	ult.effect_type = SkillData.EffectType.ULTIMATE
	ult.spirit_cost = 100.0
	ult.cooldown = 8.0
	ult.startup = 0.28
	ult.active = 0.0
	ult.recovery = 0.38
	ult.damage = 28.0
	ult.hitstun = 0.16
	ult.knockback = 40.0
	ult.reach = 120.0
	ult.ultimate_hits = 5
	ult.ultimate_hit_interval = 0.15
	ult.ultimate_finisher_damage = 105.0
	ult.launch = true
	ult.launch_velocity = -520.0
	ult.domain_duration = 5.0
	ult.domain_speed_mult = 1.1
	ult.domain_damage_mult = 1.25
	ult.domain_enemy_slow = 0.65
	ult.revival_side_effect = 18.0
	out.append(ult)

	return out
