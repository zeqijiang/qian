class_name DashState
extends State

var _dir: float = 1.0

func enter() -> void:
	super.enter()
	if not character:
		return
	_dir = character.facing
	character.velocity.x = _dir * character.stats.dash_speed * character.domain_speed_mult
	character.velocity.y = 0.0
	character.start_dash_trail()

func physics_process(delta: float) -> void:
	if not character:
		return
	character.velocity.x = _dir * character.stats.dash_speed * character.domain_speed_mult
	character.apply_gravity(delta)
	character.move_and_slide()

	if state_time >= character.stats.dash_duration:
		if character.is_on_floor():
			state_machine.force_change("Idle")
		else:
			state_machine.force_change("Fall")
		return

	if character.input_ctrl:
		if character.input_ctrl.attack_light_pressed:
			state_machine.force_change("AttackLight")
		elif character.input_ctrl.attack_heavy_pressed:
			state_machine.force_change("AttackHeavy")

func can_cancel_to(state_name: String) -> bool:
	return state_name in ["Idle", "Walk", "Fall", "AttackLight", "AttackHeavy", "Hit", "Dead"]
