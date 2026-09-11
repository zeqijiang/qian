class_name SkillState
extends State
## Generic skill cast state. SkillManager fills profile.
## Applies special effects (domain / followup / suppress / ultimate) via Character.

var profile: Dictionary = {}
var _activated: bool = false
var _effect_fired: bool = false

func configure(p: Dictionary) -> void:
	profile = p

func enter() -> void:
	super.enter()
	_activated = false
	_effect_fired = false
	if not character:
		return
	character.velocity.x = 0.0
	character.combat.start_attack(profile)
	var cost: float = float(profile.get("spirit_cost", 20.0))
	if not character.energy.spend_spirit(cost):
		state_machine.force_change("Idle")
		return
	character.energy.add_revival(float(profile.get("revival_cost_side", 6.0)))
	_apply_special_effect()

func exit() -> void:
	if character and character.combat:
		character.combat.end_attack()

func _apply_special_effect() -> void:
	_effect_fired = true
	var et := int(profile.get("effect_type", 0))
	match et:
		int(SkillData.EffectType.DOMAIN):
			character.start_domain(profile)
		int(SkillData.EffectType.GHOST_SHADOW):
			character.schedule_ghost_followup(profile)
		int(SkillData.EffectType.ULTIMATE):
			character.begin_ultimate(profile)
		_:
			pass

func physics_process(delta: float) -> void:
	if not character:
		return
	character.apply_gravity(delta)
	character.velocity.x = 0.0
	character.move_and_slide()

	var startup: float = float(profile.get("startup", 0.12))
	var active: float = float(profile.get("active", 0.12))
	var recovery: float = float(profile.get("recovery", 0.25))
	var total := startup + active + recovery

	# Domain / ultimate manage their own hitboxes after cast.
	var et := int(profile.get("effect_type", 0))
	var skip_hitbox := et in [int(SkillData.EffectType.DOMAIN), int(SkillData.EffectType.ULTIMATE)]

	if not skip_hitbox:
		if active > 0.0 and state_time >= startup and state_time < startup + active:
			if not _activated:
				_activated = true
				character.combat.activate_hitbox()
		else:
			if _activated:
				_activated = false
				character.combat.deactivate_hitbox()

	if state_time >= total:
		if character.is_on_floor():
			state_machine.force_change("Idle")
		else:
			state_machine.force_change("Fall")

func can_cancel_to(state_name: String) -> bool:
	return state_name in ["Hit", "AirHit", "Dead", "Knockdown"]
