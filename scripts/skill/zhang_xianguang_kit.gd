class_name ZhangXianguangKit
extends RefCounted
## 张羡光・画中游神 — mobility / clone / paint-rule control.

static func build_skills() -> Array[SkillData]:
	var out: Array[SkillData] = []

	# U 影遁 — invuln dash through, slash
	var dash := SkillData.new()
	dash.skill_id = "ying_dun"
	dash.display_name = "影遁"
	dash.effect_type = SkillData.EffectType.DAMAGE
	dash.spirit_cost = 20.0
	dash.cooldown = 0.5
	dash.startup = 0.06
	dash.active = 0.12
	dash.recovery = 0.14
	dash.damage = 38.0
	dash.hitstun = 0.28
	dash.knockback = 120.0
	dash.reach = 100.0
	dash.revival_side_effect = 5.0
	# custom: teleport behind on cast
	dash.unblockable = false
	out.append(dash)

	# I 影子分身 — delayed shadow strikes
	var clone := SkillData.new()
	clone.skill_id = "ying_fen"
	clone.display_name = "影子分身"
	clone.effect_type = SkillData.EffectType.GHOST_SHADOW
	clone.spirit_cost = 28.0
	clone.cooldown = 0.8
	clone.startup = 0.1
	clone.active = 0.08
	clone.recovery = 0.16
	clone.damage = 22.0
	clone.hitstun = 0.16
	clone.knockback = 70.0
	clone.reach = 70.0
	clone.followup_delay = 0.2
	clone.followup_damage = 32.0
	clone.followup_hitstun = 0.3
	clone.followup_reach = 85.0
	clone.followup_offset = 48.0
	clone.revival_side_effect = 8.0
	out.append(clone)

	# O 鬼教室 — grab + reverse controls
	var room := SkillData.new()
	room.skill_id = "gui_jiao"
	room.display_name = "鬼教室"
	room.effect_type = SkillData.EffectType.SUPPRESS
	room.spirit_cost = 35.0
	room.cooldown = 2.0
	room.startup = 0.14
	room.active = 0.1
	room.recovery = 0.24
	room.damage = 55.0
	room.hitstun = 0.5
	room.knockback = 40.0
	room.reach = 95.0
	room.suppress_duration = 1.0
	room.unblockable = true
	room.revival_side_effect = 10.0
	out.append(room)

	# Ground special slot reuse: 画影斩 as extra damage skill on H
	var ink := SkillData.new()
	ink.skill_id = "hua_ying"
	ink.display_name = "画影斩"
	ink.effect_type = SkillData.EffectType.DAMAGE
	ink.spirit_cost = 25.0
	ink.cooldown = 0.9
	ink.startup = 0.12
	ink.active = 0.12
	ink.recovery = 0.2
	ink.damage = 48.0
	ink.hitstun = 0.32
	ink.knockback = 150.0
	ink.reach = 90.0
	ink.revival_side_effect = 7.0
	out.append(ink)

	# Ultimate 桃花源
	var ult := SkillData.new()
	ult.skill_id = "ultimate"
	ult.display_name = "桃花源"
	ult.effect_type = SkillData.EffectType.ULTIMATE
	ult.spirit_cost = 100.0
	ult.cooldown = 8.0
	ult.startup = 0.22
	ult.active = 0.0
	ult.recovery = 0.32
	ult.damage = 24.0
	ult.hitstun = 0.14
	ult.knockback = 30.0
	ult.reach = 110.0
	ult.ultimate_hits = 5
	ult.ultimate_hit_interval = 0.14
	ult.ultimate_finisher_damage = 100.0
	ult.launch = true
	ult.launch_velocity = -500.0
	ult.domain_duration = 4.0
	ult.domain_speed_mult = 1.15
	ult.domain_damage_mult = 1.3
	ult.domain_enemy_slow = 0.7
	ult.revival_side_effect = 18.0
	out.append(ult)

	return out
