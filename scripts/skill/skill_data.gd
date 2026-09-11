class_name SkillData
extends Resource
## Data-driven skill definition.

@export var skill_id: String = ""
@export var display_name: String = ""
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

func to_profile() -> Dictionary:
	return {
		"name": skill_id,
		"display_name": display_name,
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
	}
