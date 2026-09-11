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
		if character.input_ctrl:
			# Swallow the press that started this attack so buffer does not re-fire.
			var aname := str(profile.get("name", ""))
			if aname == "heavy":
				character.input_ctrl.consume_attack_heavy()
			else:
				character.input_ctrl.consume_attack_light()

func exit() -> void:
	if character and character.combat:
		character.combat.end_attack()

func physics_process(delta: float) -> void:
	if not character:
		return
	character.apply_gravity(delta)
	character.velocity.x = lerpf(character.velocity.x, 0.0, 14.0 * delta)
	character.move_and_slide()

	var startup: float = float(profile.get("startup", 0.05))
	var active: float = float(profile.get("active", 0.08))
	var recovery: float = float(profile.get("recovery", 0.12))
	var total := startup + active + recovery

	if state_time >= startup and state_time < startup + active:
		if not _active:
			_active = true
			character.combat.activate_hitbox()
	else:
		if _active:
			_active = false
			character.combat.deactivate_hitbox()

	_try_cancel_inputs()

	if state_time >= total:
		if character.is_on_floor():
			state_machine.force_change("Idle")
		else:
			state_machine.force_change("Fall")

func _try_cancel_inputs() -> void:
	if not character or not character.input_ctrl:
		return
	var ic := character.input_ctrl
	if character.skills and character.skills.try_cast_from_input():
		return
	# Attacks can chain once active frames have begun.
	if state_time >= float(profile.get("startup", 0.05)) * 0.5:
		if ic.attack_light_pressed:
			if get_state_name() == "AttackLight" or can_cancel_to("AttackLight"):
				state_machine.force_change("AttackLight")
				return
		if ic.attack_heavy_pressed:
			if get_state_name() == "AttackHeavy" or can_cancel_to("AttackHeavy"):
				state_machine.force_change("AttackHeavy")
				return
		if ic.dash_pressed and can_cancel_to("Dash"):
			ic.consume_dash()
			state_machine.force_change("Dash")
			return
		if ic.jump_pressed and character.is_on_floor() and can_cancel_to("Jump"):
			ic.consume_jump()
			state_machine.force_change("Jump")
			return
	# Movement/block can cancel once active frames end.
	if state_time >= float(profile.get("startup", 0.05)) + float(profile.get("active", 0.08)):
		var axis := ic.get_move_axis()
		if absf(axis) > 0.1 and can_cancel_to("Walk"):
			state_machine.force_change("Walk")
			return
		if ic.block_held and can_cancel_to("Block"):
			state_machine.force_change("Block")
			return

func get_damage_info() -> DamageInfo:
	return character.combat.get_current_damage_info()

func can_cancel_to(state_name: String) -> bool:
	var cancel_window: float = float(profile.get("cancel_window", 0.0))
	var startup: float = float(profile.get("startup", 0.05))
	var active: float = float(profile.get("active", 0.08))
	if state_name in ["Hit", "AirHit", "Dead", "Knockdown"]:
		return true
	# Cancels open from mid-startup through active + cancel_window.
	if state_time >= startup * 0.5 and state_time < startup + active + cancel_window:
		if state_name in ["Idle", "Walk", "Dash", "Jump", "AttackLight", "AttackHeavy", "AttackAir", "Skill", "Block"]:
			return true
	return false
