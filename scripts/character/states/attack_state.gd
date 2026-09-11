class_name AttackState
extends State
## Base attack state. Subclasses configure timings via AttackProfile.

var profile: Dictionary = {}
var _active: bool = false
var _has_hit: bool = false

func configure(p: Dictionary) -> void:
	profile = p

func enter() -> void:
	super.enter()
	_active = false
	_has_hit = false
	if character:
		character.velocity.x = 0.0
		character.combat.start_attack(profile)

func exit() -> void:
	if character and character.combat:
		character.combat.end_attack()

func physics_process(delta: float) -> void:
	if not character:
		return
	character.apply_gravity(delta)
	character.velocity.x = lerpf(character.velocity.x, 0.0, 10.0 * delta)
	character.move_and_slide()

	var startup: float = float(profile.get("startup", 0.08))
	var active: float = float(profile.get("active", 0.1))
	var recovery: float = float(profile.get("recovery", 0.18))
	var total := startup + active + recovery

	if state_time >= startup and state_time < startup + active:
		if not _active:
			_active = true
			character.combat.activate_hitbox()
	else:
		if _active:
			_active = false
			character.combat.deactivate_hitbox()

	if state_time >= total:
		if character.is_on_floor():
			state_machine.force_change("Idle")
		else:
			state_machine.force_change("Fall")

func get_damage_info() -> DamageInfo:
	return character.combat.get_current_damage_info()

func can_cancel_to(state_name: String) -> bool:
	var cancel_window: float = float(profile.get("cancel_window", 0.0))
	var startup: float = float(profile.get("startup", 0.08))
	var active: float = float(profile.get("active", 0.1))
	if state_name in ["Hit", "AirHit", "Dead", "Knockdown"]:
		return true
	if state_time < startup + active + cancel_window:
		if state_name in ["Idle", "Walk", "Dash", "Jump", "AttackLight", "AttackHeavy", "AttackAir", "Skill", "Block"]:
			return true
	return false
