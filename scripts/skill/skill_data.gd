class_name SkillData
extends Resource
## Data-driven skill definition.

enum EffectType { DAMAGE, GHOST_HAND, GHOST_SHADOW, DOMAIN, SUPPRESS, ULTIMATE }

@export var skill_id: String = ""
@export var display_name: String = ""
@export var effect_type: EffectType = EffectType.DAMAGE
@export var spirit_cost: float = 20.0
@export var cooldown: float = 0.5
@export var startup: float = 0.12
@export var active: float = 0.12
@export var recovery: float = 0.25
@export var damage: float = 35.0
@export var hitstun: float = 0.25
@export var knockback: float = 160.0
@export var reach: float = 80.0
@export var launch: bool = false
@export var launch_velocity: float = -400.0
@export var revival_side_effect: float = 6.0

@export_group("鬼手")
@export var pull_force: float = 280.0

@export_group("鬼影")
@export var followup_delay: float = 0.22
@export var followup_damage: float = 28.0
@export var followup_hitstun: float = 0.2
@export var followup_reach: float = 70.0
@export var followup_offset: float = 52.0

@export_group("鬼域")
@export var domain_duration: float = 6.0
@export var domain_speed_mult: float = 1.25
@export var domain_damage_mult: float = 1.2
@export var domain_enemy_slow: float = 0.75

@export_group("鬼眼压制")
@export var suppress_duration: float = 0.7
@export var unblockable: bool = true

@export_group("奥义")
@export var ultimate_hits: int = 4
@export var ultimate_hit_interval: float = 0.18
@export var ultimate_finisher_damage: float = 80.0

func to_profile() -> Dictionary:
	return {
		"name": skill_id,
		"display_name": display_name,
		"effect_type": int(effect_type),
		"spirit_cost": spirit_cost,
		"startup": startup,
		"active": active,
		"recovery": recovery,
		"damage": damage,
		"hitstun": hitstun,
		"knockback": knockback,
		"reach": reach,
		"launch": launch,
		"launch_velocity": launch_velocity,
		"revival_cost_side": revival_side_effect,
		"pull_force": pull_force,
		"followup_delay": followup_delay,
		"followup_damage": followup_damage,
		"followup_hitstun": followup_hitstun,
		"followup_reach": followup_reach,
		"followup_offset": followup_offset,
		"domain_duration": domain_duration,
		"domain_speed_mult": domain_speed_mult,
		"domain_damage_mult": domain_damage_mult,
		"domain_enemy_slow": domain_enemy_slow,
		"suppress_duration": suppress_duration,
		"unblockable": unblockable,
		"ultimate_hits": ultimate_hits,
		"ultimate_hit_interval": ultimate_hit_interval,
		"ultimate_finisher_damage": ultimate_finisher_damage,
	}
