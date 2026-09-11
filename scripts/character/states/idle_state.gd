class_name IdleState
extends State

func enter() -> void:
	super.enter()
	if character:
		character.set_facing_from_input()
		character.velocity.x = 0.0

func physics_process(delta: float) -> void:
	if not character:
		return
	character.apply_gravity(delta)
	character.velocity.x = 0.0
	character.move_and_slide()
	if not character.is_on_floor():
		state_machine.force_change("Fall")
		return
	if character.is_suppressed():
		character.velocity.x = 0.0
		return
	if character.skills and character.skills.try_cast_from_input():
		return
	if character.input_ctrl:
		var dir := character.get_move_axis_reversed()
		if absf(dir) > 0.1:
			state_machine.force_change("Walk")
		elif character.input_ctrl.jump_pressed:
			state_machine.force_change("Jump")
		elif character.input_ctrl.dash_pressed:
			state_machine.force_change("Dash")
		elif character.input_ctrl.attack_light_pressed:
			state_machine.force_change("AttackLight")
		elif character.input_ctrl.attack_heavy_pressed:
			state_machine.force_change("AttackHeavy")
		elif character.input_ctrl.block_held:
			state_machine.force_change("Block")

func can_cancel_to(state_name: String) -> bool:
	return state_name in ["Walk", "Jump", "Fall", "Dash", "AttackLight", "AttackHeavy", "Block", "Skill", "Hit", "Dead"]
