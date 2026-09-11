class_name DeadState
extends State

func enter() -> void:
	super.enter()
	if character:
		character.velocity = Vector2.ZERO
		character.combat.deactivate_hitbox()
		character.set_invulnerable(true)
		Game.notify_death(character.character_id)

func physics_process(delta: float) -> void:
	if not character:
		return
	character.apply_gravity(delta)
	character.velocity.x = 0.0
	character.move_and_slide()

func can_cancel_to(_state_name: String) -> bool:
	return false
