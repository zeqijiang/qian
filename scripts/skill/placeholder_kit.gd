class_name PlaceholderKit
extends RefCounted
## Minimal skills so the dummy AI can spend spirit.

static func build_skills() -> Array[SkillData]:
	var out: Array[SkillData] = []

	var burst := SkillData.new()
	burst.skill_id = "burst"
	burst.display_name = "灵异爆发"
	burst.effect_type = SkillData.EffectType.DAMAGE
	burst.spirit_cost = 20.0
	burst.cooldown = 0.8
	burst.startup = 0.1
	burst.active = 0.1
	burst.recovery = 0.2
	burst.damage = 38.0
	burst.hitstun = 0.28
	burst.knockback = 160.0
	burst.reach = 85.0
	burst.revival_side_effect = 5.0
	out.append(burst)

	var shove := SkillData.new()
	shove.skill_id = "shove"
	shove.display_name = "厉鬼冲击"
	shove.effect_type = SkillData.EffectType.DAMAGE
	shove.spirit_cost = 30.0
	shove.cooldown = 1.4
	shove.startup = 0.14
	shove.active = 0.1
	shove.recovery = 0.24
	shove.damage = 55.0
	shove.hitstun = 0.35
	shove.knockback = 240.0
	shove.reach = 95.0
	shove.launch = true
	shove.launch_velocity = -420.0
	shove.revival_side_effect = 8.0
	out.append(shove)

	return out
