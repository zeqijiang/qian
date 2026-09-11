class_name Character
extends CharacterBody2D
## Base fighter. Modular: stats / FSM / combat / energy / input / AI.

signal hp_changed(current: float, max_hp: float)
signal died(character_id: int)
signal landed_hit(info: DamageInfo)
signal state_changed(old_state: String, new_state: String)

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

var state_machine: CharacterStateMachine
var combat: CombatController
var energy: EnergyManager
var input_ctrl: InputController
var ai: AIController
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

func _physics_process(_delta: float) -> void:
	if is_dead:
		return
	if not is_player_controlled and ai:
		ai.target = Game.get_opponent(self)
	# Keep facing visual in sync
	if visual:
		visual.set_facing(facing)
		visual.set_blocking(is_blocking)

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

func on_landed_hit(info: DamageInfo) -> void:
	landed_hit.emit(info)

func on_hit_received(info: DamageInfo, attacker: Character) -> void:
	if is_dead or invulnerable:
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

func reset_for_training(spawn: Vector2) -> void:
	global_position = spawn
	velocity = Vector2.ZERO
	hp = max_hp
	is_dead = false
	is_blocking = false
	invulnerable = false
	if visual:
		visual.set_dead(false)
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
