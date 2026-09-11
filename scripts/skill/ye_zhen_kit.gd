class_name YeZhenKit
extends RefCounted
## Ye Zhen: high-defense melee with armor / invuln tools.

static func build_skills() -> Array[SkillData]:
	var out: Array[SkillData] = []

	# 鬼拳·镇压 — armored charge with stun
	var charge := SkillData.new()
	charge.skill_id = "gui_quan"
	charge.display_name = "鬼拳镇压"
	charge.effect_type = SkillData.EffectType.DAMAGE
	charge.spirit_cost = 20.0
	charge.cooldown = 0.6
	charge.startup = 0.1
	charge.active = 0.14
	charge.recovery = 0.18
	charge.damage = 48.0
	charge.hitstun = 0.3
	charge.knockback = 200.0
	charge.reach = 90.0
	charge.revival_side_effect = 6.0
	out.append(charge)

	# 崩拳 — heavy single hit
	var smash := SkillData.new()
	smash.skill_id = "beng_quan"
	smash.display_name = "崩拳"
	smash.effect_type = SkillData.EffectType.DAMAGE
	smash.spirit_cost = 30.0
	smash.cooldown = 0.9
	smash.startup = 0.16
	smash.active = 0.1
	smash.recovery = 0.22
	smash.damage = 70.0
	smash.hitstun = 0.4
	smash.knockback = 260.0
	smash.reach = 80.0
	smash.launch = true
	smash.launch_velocity = -360.0
	smash.revival_side_effect = 8.0
	out.append(smash)

	# 铁壁 — brief invulnerability / guard
	var wall := SkillData.new()
	wall.skill_id = "tie_bi"
	wall.display_name = "铁壁"
	wall.effect_type = SkillData.EffectType.DOMAIN  # buff shell; duration fields reused
	wall.spirit_cost = 25.0
	wall.cooldown = 3.0
	wall.startup = 0.08
	wall.active = 0.0
	wall.recovery = 0.12
	wall.damage = 0.0
	wall.hitstun = 0.0
	wall.knockback = 0.0
	wall.reach = 0.0
	wall.domain_duration = 1.2
	wall.domain_speed_mult = 1.0
	wall.domain_damage_mult = 0.85  # tank window: slightly less dmg out
	wall.domain_enemy_slow = 1.0
	wall.revival_side_effect = 5.0
	out.append(wall)

	# 霸体重击 — super armor strike (uses unblockable-ish pressure)
	var armor := SkillData.new()
	armor.skill_id = "ba_ti"
	armor.display_name = "霸体重击"
	armor.effect_type = SkillData.EffectType.DAMAGE
	armor.spirit_cost = 35.0
	armor.cooldown = 1.5
	armor.startup = 0.18
	armor.active = 0.12
	armor.recovery = 0.28
	armor.damage = 85.0
	armor.hitstun = 0.45
	armor.knockback = 300.0
	armor.reach = 95.0
	armor.unblockable = false
	armor.launch = true
	armor.launch_velocity = -400.0
	armor.revival_side_effect = 10.0
	out.append(armor)

	# 奥义：绝对防御反击 — invuln into multi-hit counter
	var ult := SkillData.new()
	ult.skill_id = "ultimate"
	ult.display_name = "绝对反击"
	ult.effect_type = SkillData.EffectType.ULTIMATE
	ult.spirit_cost = 100.0
	ult.cooldown = 8.0
	ult.startup = 0.2
	ult.active = 0.0
	ult.recovery = 0.3
	ult.damage = 28.0
	ult.hitstun = 0.18
	ult.knockback = 40.0
	ult.reach = 100.0
	ult.ultimate_hits = 3
	ult.ultimate_hit_interval = 0.18
	ult.ultimate_finisher_damage = 110.0
	ult.launch = true
	ult.launch_velocity = -560.0
	ult.domain_duration = 1.5
	ult.domain_speed_mult = 1.05
	ult.domain_damage_mult = 1.15
	ult.domain_enemy_slow = 1.0
	ult.revival_side_effect = 20.0
	out.append(ult)

	return out
