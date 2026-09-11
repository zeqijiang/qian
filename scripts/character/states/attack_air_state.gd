class_name AttackAirState
extends AttackState

func enter() -> void:
	if profile.is_empty():
		configure({
			"name": "air",
			"startup": 0.05,
			"active": 0.10,
			"recovery": 0.12,
			"cancel_window": 0.08,
			"damage": 30.0,
			"hitstun": 0.22,
			"knockback": 110.0,
			"reach": 62.0,
			"spirit_gain": 10.0,
		})
	super.enter()

func physics_process(delta: float) -> void:
	if not character:
		return
	character.apply_gravity(delta)
	if character.input_ctrl:
		var dir := character.input_ctrl.get_move_axis()
		character.velocity.x = dir * character.stats.move_speed * character.stats.air_control * 0.5
	character.move_and_slide()

	var startup: float = float(profile.get("startup", 0.05))
	var active: float = float(profile.get("active", 0.10))
	var recovery: float = float(profile.get("recovery", 0.12))
	var total := startup + active + recovery

	if state_time >= startup and state_time < startup + active:
		if not _active:
			_active = true
			character.combat.activate_hitbox()
	else:
		if _active:
			_active = false
			character.combat.deactivate_hitbox()

	if state_time >= total:
		if character.is_on_floor():
			state_machine.force_change("Idle")
		else:
			state_machine.force_change("Fall")

func is_airborne_state() -> bool:
	return true
