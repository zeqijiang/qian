class_name GetUpState
extends State

const GETUP_DURATION := 0.35
const INVULN_TIME := 0.25

func enter() -> void:
	super.enter()
	if character:
		character.set_invulnerable(true)
		character.velocity = Vector2.ZERO

func exit() -> void:
	if character:
		character.set_invulnerable(false)

func physics_process(delta: float) -> void:
	if not character:
		return
	character.apply_gravity(delta)
	character.velocity.x = 0.0
	character.move_and_slide()
	if state_time >= GETUP_DURATION:
		state_machine.force_change("Idle")

func can_cancel_to(state_name: String) -> bool:
	return state_name in ["Idle", "Dead"]
