class_name FallState
extends State

func enter() -> void:
	super.enter()

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
		if character.input_ctrl.dash_pressed and character.can_air_dash:
			state_machine.force_change("Dash")
			return
	character.move_and_slide()
	if character.is_on_floor():
		character.land()
		state_machine.force_change("Idle")

func is_airborne_state() -> bool:
	return true

func can_cancel_to(state_name: String) -> bool:
	return state_name in ["Idle", "Walk", "AttackAir", "Dash", "Hit", "AirHit", "Dead"]
