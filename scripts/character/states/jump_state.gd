class_name JumpState
extends State

func enter() -> void:
	super.enter()
	if character:
		character.velocity.y = character.stats.jump_velocity
		character.consume_jump()

func physics_process(delta: float) -> void:
	if not character:
		return
	character.apply_gravity(delta)
	if character.input_ctrl:
		var dir := character.input_ctrl.get_move_axis()
		character.velocity.x = dir * character.stats.move_speed * character.stats.air_control
		character.set_facing(dir)
		if character.input_ctrl.attack_light_pressed:
			state_machine.force_change("AttackAir")
			return
	character.move_and_slide()
	if character.velocity.y >= 0.0:
		state_machine.force_change("Fall")

func is_airborne_state() -> bool:
	return true

func can_cancel_to(state_name: String) -> bool:
	return state_name in ["Fall", "AttackAir", "Dash", "Hit", "AirHit", "Dead"]
