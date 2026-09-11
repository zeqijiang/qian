class_name DamageInfo
extends Resource
## Immutable-ish payload describing one hit.

@export var base_damage: float = 20.0
@export var skill_multiplier: float = 1.0
@export var hitstun: float = 0.15
@export var blockstun: float = 0.1
@export var knockback: float = 120.0
@export var launch: bool = false
@export var launch_velocity: float = -420.0
@export var super_armor: bool = false
@export var unblockable: bool = false
@export var chip_damage_ratio: float = 0.15
@export var attack_name: String = "light"
@export var hit_pause: float = 0.05

func compute_damage(defense_modifier: float = 1.0, state_modifier: float = 1.0) -> float:
	return maxf(0.0, base_damage * skill_multiplier * defense_modifier * state_modifier)
