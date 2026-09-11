class_name KnockdownState
extends State

const GETUP_TIME := 0.7

func enter() -> void:
	super.enter()
	if character:
		character.velocity = Vector2.ZERO
		character.combat.deactivate_hitbox()

func physics_process(delta: float) -> void:
	if not character:
		return
	character.apply_gravity(delta)
	character.velocity.x = 0.0
	character.move_and_slide()
	if state_time >= GETUP_TIME:
		state_machine.force_change("GetUp")

func can_cancel_to(state_name: String) -> bool:
	return state_name in ["GetUp", "Dead"]
