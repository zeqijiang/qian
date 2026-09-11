class_name WalkState
extends State

func enter() -> void:
	super.enter()

func physics_process(delta: float) -> void:
	if not character:
		return
	character.apply_gravity(delta)
	if character.is_suppressed():
		character.velocity.x = 0.0
		character.move_and_slide()
		return
	var dir := 0.0
	if character.input_ctrl:
		dir = character.get_move_axis_reversed()
		character.set_facing(dir)
	character.velocity.x = dir * character.get_move_speed()
	character.move_and_slide()

	if not character.is_on_floor():
		state_machine.force_change("Fall")
		return

	if character.skills and character.skills.try_cast_from_input():
		return

	if character.input_ctrl:
		if absf(dir) < 0.1:
			state_machine.force_change("Idle")
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
	return state_name in ["Idle", "Jump", "Fall", "Dash", "AttackLight", "AttackHeavy", "Block", "Skill", "Hit", "Dead"]
