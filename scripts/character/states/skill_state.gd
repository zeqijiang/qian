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
	var sid := str(profile.get("name", ""))
	match et:
		int(SkillData.EffectType.DOMAIN):
			if sid == "tie_bi":
				character.apply_invuln_buff(float(profile.get("domain_duration", 1.0)))
			else:
				character.start_domain(profile)
				if sid == "gui_yan_smoke":
					character.apply_stealth(float(profile.get("domain_duration", 5.0)) * 0.8)
					var target := Game.get_opponent(character)
					if target is Character:
						(target as Character).apply_smoke_slow(float(profile.get("domain_duration", 5.0)))
		int(SkillData.EffectType.GHOST_SHADOW):
			character.schedule_ghost_followup(profile)
			if sid == "ying_fen" and CombatFX:
				CombatFX.show_skill_banner("影子分身", "协同攻击", 0.6)
		int(SkillData.EffectType.ULTIMATE):
			if character.stats and character.stats.character_name == "ye_zhen":
				character.apply_invuln_buff(0.55)
			if character.stats and character.stats.character_name == "li_leping":
				# Blow mark for bonus finisher if marked
				var t := Game.get_opponent(character)
				if t is Character and (t as Character).marked_left > 0.0:
					(t as Character).damage_taken_mult = 1.8
			character.begin_ultimate(profile)
		int(SkillData.EffectType.SUPPRESS):
			# Applied on hit via on_landed_hit for mark/classroom
			pass
		_:
			pass
	if sid == "ba_ti":
		var armor_t: float = float(profile.get("startup", 0.15)) + float(profile.get("active", 0.12))
		character.apply_super_armor(armor_t)
	if sid == "tie_chong":
		character.apply_super_armor(float(profile.get("active", 0.14)) + 0.05)
	if sid in ["ying_dun", "yi_wang"]:
		character.apply_invuln_buff(float(profile.get("startup", 0.06)) + float(profile.get("active", 0.1)) + 0.05)
		var target := Game.get_opponent(character)
		if target is Character:
			character.teleport_behind(target as Character, 40.0)
		if CombatFX:
			CombatFX.show_skill_banner("影遁" if sid == "ying_dun" else "遗忘", "", 0.45)

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
