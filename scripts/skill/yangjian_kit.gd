class_name YangJianKit
extends RefCounted
## Builds Yang Jian's skill loadout. Keep numbers data-driven here.

static func build_skills() -> Array[SkillData]:
	var out: Array[SkillData] = []

	# U 鬼眼·定位 — lock and blink to target
	var locate := SkillData.new()
	locate.skill_id = "gui_ding_wei"
	locate.display_name = "鬼眼定位"
	locate.effect_type = SkillData.EffectType.DAMAGE
	locate.spirit_cost = 20.0
	locate.cooldown = 0.4
	locate.startup = 0.06
	locate.active = 0.1
	locate.recovery = 0.14
	locate.damage = 40.0
	locate.hitstun = 0.3
	locate.knockback = 100.0
	locate.reach = 90.0
	locate.revival_side_effect = 5.0
	out.append(locate)

	# I 鬼域·红雾
	var domain := SkillData.new()
	domain.skill_id = "gui_yu"
	domain.display_name = "鬼域红雾"
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

	# O 棺材钉·锁死
	var nail := SkillData.new()
	nail.skill_id = "guan_cai_ding"
	nail.display_name = "棺材钉"
	nail.effect_type = SkillData.EffectType.SUPPRESS
	nail.spirit_cost = 35.0
	nail.cooldown = 2.5
	nail.startup = 0.14
	nail.active = 0.1
	nail.recovery = 0.24
	nail.damage = 30.0
	nail.hitstun = 0.25
	nail.knockback = 20.0
	nail.reach = 100.0
	nail.suppress_duration = 2.0
	nail.unblockable = true
	nail.revival_side_effect = 10.0
	out.append(nail)

	# H 鬼影
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

	# P 奥义
	var ult := SkillData.new()
	ult.skill_id = "ultimate"
	ult.display_name = "无解封印"
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
