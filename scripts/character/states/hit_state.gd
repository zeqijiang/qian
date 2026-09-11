class_name HitState
extends State

var hitstun_duration: float = 0.15
var knockback_velocity: float = 0.0

func enter() -> void:
	super.enter()
	if character:
		character.is_blocking = false
		character.combat.deactivate_hitbox()
		character.velocity.x = knockback_velocity
		if not character.is_on_floor():
			character.velocity.y = minf(character.velocity.y, -80.0)

func physics_process(delta: float) -> void:
	if not character:
		return
	character.apply_gravity(delta)
	character.velocity.x = lerpf(character.velocity.x, 0.0, 6.0 * delta)
	character.move_and_slide()
	if state_time >= hitstun_duration:
		if character.is_on_floor():
			state_machine.force_change("Idle")
		else:
			state_machine.force_change("Fall")

func can_cancel_to(state_name: String) -> bool:
	return state_name in ["Idle", "Fall", "AirHit", "Knockdown", "Dead"]

func is_airborne_state() -> bool:
	return true
