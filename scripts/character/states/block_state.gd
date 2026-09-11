class_name BlockState
extends State

func enter() -> void:
	super.enter()
	if character:
		character.velocity.x = 0.0
		character.is_blocking = true

func exit() -> void:
	if character:
		character.is_blocking = false

func physics_process(delta: float) -> void:
	if not character:
		return
	character.apply_gravity(delta)
	character.velocity.x = 0.0
	character.move_and_slide()
	if character.input_ctrl and not character.input_ctrl.block_held:
		state_machine.force_change("Idle")
	if not character.is_on_floor():
		state_machine.force_change("Fall")

func can_cancel_to(state_name: String) -> bool:
	return state_name in ["Idle", "Walk", "Hit", "Dead"]
