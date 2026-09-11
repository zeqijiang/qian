class_name AirHitState
extends State

var hitstun_duration: float = 0.25
var knockback_velocity: float = 0.0

func enter() -> void:
	super.enter()
	if character:
		character.combat.deactivate_hitbox()
		character.velocity.x = knockback_velocity
		character.velocity.y = minf(character.velocity.y, -200.0)

func physics_process(delta: float) -> void:
	if not character:
		return
	character.apply_gravity(delta)
	character.velocity.x = lerpf(character.velocity.x, 0.0, 2.0 * delta)
	character.move_and_slide()
	if character.is_on_floor() and state_time > 0.05:
		state_machine.force_change("Knockdown")
		return
	if state_time >= hitstun_duration and character.is_on_floor():
		state_machine.force_change("Idle")

func can_cancel_to(state_name: String) -> bool:
	return state_name in ["Knockdown", "Idle", "Dead"]

func is_airborne_state() -> bool:
	return true
