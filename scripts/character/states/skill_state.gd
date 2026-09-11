class_name SkillState
extends State
## Generic skill cast state. SkillManager fills profile.

var profile: Dictionary = {}
var _activated: bool = false

func configure(p: Dictionary) -> void:
	profile = p

func enter() -> void:
	super.enter()
	_activated = false
	if character:
		character.velocity.x = 0.0
		character.combat.start_attack(profile)
		var cost: float = float(profile.get("spirit_cost", 20.0))
		if not character.energy.spend_spirit(cost):
			state_machine.force_change("Idle")
			return
		character.energy.add_revival(float(profile.get("revival_cost_side", 6.0)))

func exit() -> void:
	if character and character.combat:
		character.combat.end_attack()

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

	if state_time >= startup and state_time < startup + active:
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
