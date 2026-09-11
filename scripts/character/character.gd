class_name Character
extends CharacterBody2D
## Base fighter. Modular: stats / FSM / combat / energy / input / AI.

signal hp_changed(current: float, max_hp: float)
signal died(character_id: int)
signal landed_hit(info: DamageInfo)
signal state_changed(old_state: String, new_state: String)
signal domain_changed(active: bool)
signal skill_cast(skill_id: String)

const GRAVITY := GameConstants.GRAVITY

@export var character_id: int = 0
@export var team_id: int = 0
@export var is_player_controlled: bool = true
@export var stats_resource: CharacterStats

var stats: CharacterStats
var hp: float = 1000.0
var max_hp: float = 1000.0
var facing: int = 1
var is_dead: bool = false
var invulnerable: bool = false
var is_blocking: bool = false
var can_air_dash: bool = true
var defense_modifier: float = 1.0
var state_modifier: float = 1.0

# 灵异机制
var domain_active: bool = false
var domain_timer: float = 0.0
var domain_speed_mult: float = 1.0
var domain_damage_mult: float = 1.0
var domain_slow_left: float = 0.0
var domain_slow_mult: float = 1.0
var suppress_left: float = 0.0
var armor_left: float = 0.0
var invuln_buff_left: float = 0.0
var _ultimate_running: bool = false

var state_machine: CharacterStateMachine
var combat: CombatController
var energy: EnergyManager
var input_ctrl: InputController
var ai: AIController
var skills: SkillManager
var visual: PlaceholderVisual

@onready var _hurtbox: Hurtbox = $Hurtbox
@onready var _hitbox: Hitbox = $Hitbox
@onready var _collision: CollisionShape2D = $CollisionShape2D
@onready var _visual_root: Node2D = $VisualRoot

func _ready() -> void:
	stats = stats_resource.clone() if stats_resource else CharacterStats.new()
	max_hp = stats.max_hp
	hp = max_hp

	state_machine = $StateMachine
	state_machine.setup(self)
	_setup_states()

	combat = CombatController.new()
	combat.name = "CombatController"
	add_child(combat)
	combat.setup(self)

	energy = combat.energy

	input_ctrl = InputController.new()
	input_ctrl.name = "InputController"
	input_ctrl.process_priority = -10
	add_child(input_ctrl)
	if not is_player_controlled:
		input_ctrl.set_ai_driven()

	if not is_player_controlled:
		ai = AIController.new()
		ai.name = "AIController"
		ai.process_priority = -20
		ai.difficulty = AIController.Difficulty.NORMAL
		add_child(ai)
		ai.setup(self, input_ctrl)

	combat.bind_hitbox(_hitbox)
	_hurtbox.owner_character = self
	_hitbox.owner_character = self

	skills = SkillManager.new()
	skills.name = "SkillManager"
	add_child(skills)
	skills.setup(self)
	skills.load_kit_for_character(stats.character_name)

	visual = PlaceholderVisual.new()
	visual.name = "PlaceholderVisual"
	_visual_root.add_child(visual)
	visual.setup(stats)

	_apply_team_collision()
	state_machine.start()
	Game.register_character(self)

	if Game.training_mode:
		energy.set_training_infinite()

	hp_changed.emit(hp, max_hp)

func _setup_states() -> void:
	# States are expected as children of StateMachine in the scene.
	# If missing (script-only setup), create defaults.
	var required := [
		"Idle", "Walk", "Jump", "Fall", "Dash", "Block",
		"AttackLight", "AttackHeavy", "AttackAir", "Skill",
		"Hit", "AirHit", "Knockdown", "GetUp", "Dead",
	]
	var scripts := {
		"Idle": IdleState,
		"Walk": WalkState,
		"Jump": JumpState,
		"Fall": FallState,
		"Dash": DashState,
		"Block": BlockState,
		"AttackLight": AttackLightState,
		"AttackHeavy": AttackHeavyState,
		"AttackAir": AttackAirState,
		"Skill": SkillState,
		"Hit": HitState,
		"AirHit": AirHitState,
		"Knockdown": KnockdownState,
		"GetUp": GetUpState,
		"Dead": DeadState,
	}
	for sname in required:
		if state_machine.get_node_or_null(sname) == null:
			var st: State = scripts[sname].new()
			st.name = sname
			state_machine.add_child(st)
	# Re-collect
	state_machine.states.clear()
	for child in state_machine.get_children():
		if child is State:
			state_machine.states[child.name] = child
			child.state_machine = state_machine
			child.character = self

func _apply_team_collision() -> void:
	if team_id == 0:
		collision_layer = GameConstants.LAYER_PLAYER
	else:
		collision_layer = GameConstants.LAYER_ENEMY
	collision_mask = GameConstants.LAYER_WORLD

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	if not is_player_controlled and ai:
		ai.target = Game.get_opponent(self)
	_tick_domain(delta)
	_tick_suppress(delta)
	if visual:
		visual.set_facing(facing)
		visual.set_blocking(is_blocking)
		visual.set_domain(domain_active)

func get_move_speed() -> float:
	var spd := stats.move_speed * domain_speed_mult * domain_slow_mult
	return spd

func is_suppressed() -> bool:
	return suppress_left > 0.0

func _tick_domain(delta: float) -> void:
	if domain_timer > 0.0:
		domain_timer -= delta
		if domain_timer <= 0.0:
			end_domain()
	if domain_slow_left > 0.0:
		domain_slow_left -= delta
		if domain_slow_left <= 0.0:
			domain_slow_mult = 1.0

func _tick_suppress(delta: float) -> void:
	if suppress_left > 0.0:
		suppress_left -= delta
	if armor_left > 0.0:
		armor_left -= delta
	if invuln_buff_left > 0.0:
		invuln_buff_left -= delta

func apply_invuln_buff(duration: float) -> void:
	invuln_buff_left = maxf(invuln_buff_left, duration)
	_flash_visual(0.6)

func apply_super_armor(duration: float) -> void:
	armor_left = maxf(armor_left, duration)
	if visual:
		visual.set_flash(0.4)

func start_domain(profile: Dictionary) -> void:
	domain_active = true
	domain_timer = maxf(domain_timer, float(profile.get("domain_duration", 6.0)))
	domain_speed_mult = float(profile.get("domain_speed_mult", 1.25))
	domain_damage_mult = float(profile.get("domain_damage_mult", 1.2))
	var slow := float(profile.get("domain_enemy_slow", 0.75))
	for c in Game.characters:
		if c != self and c is Character:
			(c as Character).apply_domain_slow(slow, domain_timer)
	if visual:
		visual.set_domain(true)
	domain_changed.emit(true)

func end_domain() -> void:
	domain_active = false
	domain_timer = 0.0
	domain_speed_mult = 1.0
	domain_damage_mult = 1.0
	if visual:
		visual.set_domain(false)
	domain_changed.emit(false)

func apply_domain_slow(mult: float, duration: float) -> void:
	domain_slow_mult = mult
	domain_slow_left = maxf(domain_slow_left, duration)

func apply_suppress(duration: float) -> void:
	suppress_left = maxf(suppress_left, duration)
	velocity.x = 0.0
	if visual:
		visual.set_flash(1.0)

func schedule_ghost_followup(profile: Dictionary) -> void:
	var delay := float(profile.get("followup_delay", 0.22))
	var origin := global_position
	var dir := float(facing)
	var dmg := float(profile.get("followup_damage", 28.0))
	var hitstun := float(profile.get("followup_hitstun", 0.28))
	var reach := float(profile.get("followup_reach", 72.0))
	var offset := float(profile.get("followup_offset", 56.0))
	var timer := get_tree().create_timer(delay)
	timer.timeout.connect(func() -> void:
		if is_dead:
			return
		_fire_ghost_strike(origin + Vector2(offset * dir, -48.0), dmg, hitstun, reach, dir)
	)

func _fire_ghost_strike(at: Vector2, damage: float, hitstun: float, reach: float, dir: float) -> void:
	var target := Game.get_opponent(self)
	if target == null or not (target is Character):
		return
	var tc: Character = target
	if tc.is_dead or tc.invulnerable:
		return
	# Ghost strike is a delayed point hit: range check + apply damage pipeline.
	var dx := tc.global_position.x - at.x
	if absf(dx) > reach + 40.0:
		return
	if signf(dx) != 0.0 and signf(dir) != 0.0 and signf(dx) != signf(dir):
		# Allow slight cross-up for ghost style; still require roughly in front unless very close.
		if absf(dx) > 30.0:
			return
	var info := DamageInfo.new()
	info.base_damage = damage
	info.skill_multiplier = stats.attack * domain_damage_mult
	info.hitstun = hitstun
	info.knockback = 100.0
	info.attack_name = "gui_ying_followup"
	tc.on_hit_received(info, self)
	combat.combo.register_hit("gui_ying_followup", damage)
	energy.add_spirit(stats.spirit_gain_on_hit)
	# Ghost flash on caster
	if visual:
		visual.set_flash(0.5)

func begin_ultimate(profile: Dictionary) -> void:
	if _ultimate_running:
		return
	_ultimate_running = true
	start_domain(profile)
	var hits := int(profile.get("ultimate_hits", 4))
	var interval := float(profile.get("ultimate_hit_interval", 0.16))
	var base_dmg := float(profile.get("damage", 22.0))
	var finisher := float(profile.get("ultimate_finisher_damage", 90.0))
	_run_ultimate_sequence(hits, interval, base_dmg, finisher, profile)

func _run_ultimate_sequence(hits: int, interval: float, base_dmg: float, finisher: float, profile: Dictionary) -> void:
	for i in hits:
		await get_tree().create_timer(interval).timeout
		if is_dead:
			_ultimate_running = false
			return
		_ultimate_pulse(base_dmg, 0.14, false, i)
	# Finisher
	await get_tree().create_timer(interval).timeout
	if not is_dead:
		_ultimate_pulse(finisher, 0.4, bool(profile.get("launch", true)), hits)
	_ultimate_running = false

func _ultimate_pulse(damage: float, hitstun: float, launch: bool, index: int) -> void:
	var target := Game.get_opponent(self)
	if target == null or not (target is Character):
		return
	var tc: Character = target
	if tc.is_dead:
		return
	# Pull toward target slightly during ultimate
	var to_t := tc.global_position - global_position
	if absf(to_t.x) > 70.0:
		global_position.x += signf(to_t.x) * minf(40.0, absf(to_t.x) - 40.0)
	face_towards(tc.global_position.x)
	var info := DamageInfo.new()
	info.base_damage = damage
	info.skill_multiplier = stats.attack * domain_damage_mult
	info.hitstun = hitstun
	info.knockback = 40.0 if not launch else 80.0
	info.launch = launch
	info.launch_velocity = -520.0 if launch else 0.0
	info.unblockable = index >= 0
	info.attack_name = "ultimate_%d" % index
	tc.on_hit_received(info, self)
	combat.combo.register_hit(info.attack_name, damage)
	energy.add_spirit(stats.spirit_gain_on_hit * 0.5)
	if visual:
		visual.set_flash(0.7)

func get_effective_damage_multiplier() -> float:
	return domain_damage_mult

func on_landed_hit(info: DamageInfo) -> void:
	landed_hit.emit(info)
	# 鬼手 pull on dedicated hit
	if info and info.attack_name == "gui_shou":
		var target := Game.get_opponent(self)
		if target is Character:
			var tc: Character = target
			var pull := 320.0
			var st = skills.get_skill("gui_shou") if skills else null
			if st:
				pull = st.pull_force
			tc.velocity.x = signf(global_position.x - tc.global_position.x) * pull
	# 鬼眼压制 root
	if info and info.attack_name == "gui_yan":
		var target := Game.get_opponent(self)
		if target is Character:
			var dur := 0.75
			var st = skills.get_skill("gui_yan") if skills else null
			if st:
				dur = st.suppress_duration
			(target as Character).apply_suppress(dur)

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y = minf(velocity.y + GRAVITY * stats.gravity_scale * delta, GameConstants.MAX_FALL_SPEED)

func set_facing(dir: float) -> void:
	if absf(dir) < 0.1:
		return
	facing = 1 if dir > 0.0 else -1
	if visual:
		visual.set_facing(facing)

func set_facing_from_input() -> void:
	if input_ctrl:
		set_facing(input_ctrl.get_move_axis())

func face_towards(world_x: float) -> void:
	set_facing(world_x - global_position.x)

func consume_jump() -> void:
	pass

func land() -> void:
	can_air_dash = true

func start_dash_trail() -> void:
	pass

func set_invulnerable(v: bool) -> void:
	invulnerable = v

func on_state_changed(old_state: String, new_state: String) -> void:
	state_changed.emit(old_state, new_state)

func get_state_name() -> String:
	return state_machine.current_state_name if state_machine else ""

func is_airborne() -> bool:
	return not is_on_floor()

func on_hit_received(info: DamageInfo, attacker: Character) -> void:
	if is_dead or invulnerable:
		return
	if invuln_buff_left > 0.0:
		return
	if Debug.invincible and is_player_controlled:
		return
	if armor_left > 0.0:
		# Super armor: take damage, ignore hitstun/knockdown
		var def_mod := 1.0 / maxf(stats.defense, 0.01) * defense_modifier
		var dmg := info.compute_damage(def_mod, state_modifier)
		hp = maxf(0.0, hp - dmg)
		hp_changed.emit(hp, max_hp)
		_spawn_damage_popup(dmg, info)
		_flash_visual(0.35)
		if energy:
			energy.add_spirit(stats.spirit_gain_on_hurt * 0.5)
		if hp <= 0.0:
			_die()
		return
	if is_blocking and not info.unblockable:
		_apply_block(info, attacker)
		return
	_apply_damage(info, attacker)

func _apply_block(info: DamageInfo, _attacker: Character) -> void:
	var chip := info.compute_damage(1.0 / maxf(stats.defense, 0.01), 1.0) * info.chip_damage_ratio
	hp = maxf(0.0, hp - chip)
	hp_changed.emit(hp, max_hp)
	if state_machine and state_machine.current_state_name == "Block":
		velocity.x = -facing * info.knockback * 0.25
	if energy:
		energy.add_spirit(stats.spirit_gain_on_hurt * 0.5)
	_flash_visual(0.3)
	if hp <= 0.0:
		_die()

func _apply_damage(info: DamageInfo, attacker: Character) -> void:
	var def_mod := 1.0 / maxf(stats.defense, 0.01) * defense_modifier
	var dmg := info.compute_damage(def_mod, state_modifier)
	hp = maxf(0.0, hp - dmg)
	hp_changed.emit(hp, max_hp)
	_spawn_damage_popup(dmg, info)

	if energy:
		energy.add_spirit(stats.spirit_gain_on_hurt)
		energy.add_revival(stats.revival_gain_on_hurt)

	var kb_dir := 1.0
	if attacker:
		kb_dir = 1.0 if global_position.x >= attacker.global_position.x else -1.0
		face_towards(attacker.global_position.x)

	_flash_visual(0.8)

	if hp <= 0.0:
		_die()
		return

	if state_machine:
		if info.launch or not is_on_floor():
			var air: AirHitState = state_machine.states.get("AirHit") as AirHitState
			if air:
				air.hitstun_duration = maxf(info.hitstun, 0.2)
				air.knockback_velocity = kb_dir * info.knockback
			if info.launch:
				velocity.y = info.launch_velocity
			state_machine.force_change("AirHit")
		else:
			var hit: HitState = state_machine.states.get("Hit") as HitState
			if hit:
				hit.hitstun_duration = info.hitstun
				hit.knockback_velocity = kb_dir * info.knockback
			state_machine.force_change("Hit")

	if attacker and attacker.combat and attacker.combat.combo:
		pass  # combo already registered on attacker side

func _die() -> void:
	is_dead = true
	if visual:
		visual.set_dead(true)
	if state_machine:
		state_machine.force_change("Dead")
	died.emit(character_id)

func _flash_visual(amount: float) -> void:
	if visual:
		visual.set_flash(amount)

func _spawn_damage_popup(dmg: float, info: DamageInfo) -> void:
	var parent := get_parent()
	if parent == null:
		return
	var crit := dmg >= 45.0 or (info and info.launch)
	var col := Color(1.0, 0.85, 0.35) if crit else Color(1.0, 0.55, 0.45)
	var at := global_position + Vector2(randf_range(-12, 12), -body_top())
	DamagePopup.spawn(parent, at, str(int(round(dmg))), col, crit)

func body_top() -> float:
	return stats.body_height if stats else 96.0

func reset_for_training(spawn: Vector2) -> void:
	global_position = spawn
	velocity = Vector2.ZERO
	hp = max_hp
	is_dead = false
	is_blocking = false
	invulnerable = false
	suppress_left = 0.0
	armor_left = 0.0
	invuln_buff_left = 0.0
	_ultimate_running = false
	end_domain()
	domain_slow_mult = 1.0
	domain_slow_left = 0.0
	if visual:
		visual.set_dead(false)
		visual.set_domain(false)
	if energy:
		energy.reset()
		energy.set_training_infinite()
	if combat and combat.combo:
		combat.combo.reset()
	if state_machine:
		state_machine.force_change("Idle")
	hp_changed.emit(hp, max_hp)

func get_debug_text() -> String:
	var en := energy if energy else null
	return "%s\nHP: %d/%d\nState: %s\nSpirit: %d\nRevival: %d" % [
		stats.display_name if stats else "?",
		int(hp), int(max_hp),
		get_state_name(),
		int(en.spirit) if en else 0,
		int(en.revival) if en else 0,
	]
