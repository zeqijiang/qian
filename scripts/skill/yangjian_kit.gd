class_name YangJianKit
extends RefCounted
## Builds Yang Jian's skill loadout. Keep numbers data-driven here.

static func build_skills() -> Array[SkillData]:
	var out: Array[SkillData] = []

	var hand := SkillData.new()
	hand.skill_id = "gui_shou"
	hand.display_name = "鬼手"
	hand.effect_type = SkillData.EffectType.GHOST_HAND
	hand.spirit_cost = 20.0
	hand.cooldown = 0.45
	hand.startup = 0.08
	hand.active = 0.1
	hand.recovery = 0.18
	hand.damage = 42.0
	hand.hitstun = 0.38
	hand.knockback = 40.0
	hand.reach = 78.0
	hand.pull_force = 320.0
	hand.revival_side_effect = 5.0
	out.append(hand)

	var shadow := SkillData.new()
	shadow.skill_id = "gui_ying"
	shadow.display_name = "鬼影"
	shadow.effect_type = SkillData.EffectType.GHOST_SHADOW
	shadow.spirit_cost = 25.0
	shadow.cooldown = 0.7
	shadow.startup = 0.1
	shadow.active = 0.08
	shadow.recovery = 0.16
	shadow.damage = 24.0
	shadow.hitstun = 0.18
	shadow.knockback = 80.0
	shadow.reach = 64.0
	shadow.followup_delay = 0.24
	shadow.followup_damage = 30.0
	shadow.followup_hitstun = 0.28
	shadow.followup_reach = 72.0
	shadow.followup_offset = 56.0
	shadow.revival_side_effect = 7.0
	out.append(shadow)

	var domain := SkillData.new()
	domain.skill_id = "gui_yu"
	domain.display_name = "鬼域"
	domain.effect_type = SkillData.EffectType.DOMAIN
	domain.spirit_cost = 35.0
	domain.cooldown = 4.0
	domain.startup = 0.2
	domain.active = 0.0
	domain.recovery = 0.22
	domain.damage = 10.0
	domain.hitstun = 0.1
	domain.knockback = 60.0
	domain.reach = 120.0
	domain.domain_duration = 6.0
	domain.domain_speed_mult = 1.25
	domain.domain_damage_mult = 1.2
	domain.domain_enemy_slow = 0.75
	domain.revival_side_effect = 12.0
	out.append(domain)

	var eye := SkillData.new()
	eye.skill_id = "gui_yan"
	eye.display_name = "鬼眼压制"
	eye.effect_type = SkillData.EffectType.SUPPRESS
	eye.spirit_cost = 30.0
	eye.cooldown = 1.2
	eye.startup = 0.12
	eye.active = 0.08
	eye.recovery = 0.2
	eye.damage = 18.0
	eye.hitstun = 0.2
	eye.knockback = 20.0
	eye.reach = 110.0
	eye.suppress_duration = 0.75
	eye.unblockable = true
	eye.revival_side_effect = 8.0
	out.append(eye)

	var ult := SkillData.new()
	ult.skill_id = "ultimate"
	ult.display_name = "多重灵异压制"
	ult.effect_type = SkillData.EffectType.ULTIMATE
	ult.spirit_cost = 100.0
	ult.cooldown = 8.0
	ult.startup = 0.25
	ult.active = 0.0
	ult.recovery = 0.35
	ult.damage = 22.0
	ult.hitstun = 0.16
	ult.knockback = 30.0
	ult.reach = 90.0
	ult.ultimate_hits = 4
	ult.ultimate_hit_interval = 0.16
	ult.ultimate_finisher_damage = 90.0
	ult.launch = true
	ult.launch_velocity = -520.0
	ult.revival_side_effect = 18.0
	ult.domain_duration = 2.5
	ult.domain_speed_mult = 1.15
	ult.domain_damage_mult = 1.25
	ult.domain_enemy_slow = 0.7
	out.append(ult)

	return out
