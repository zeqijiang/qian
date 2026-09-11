class_name AIController
extends Node
## Simple fighting-game AI. Difficulty controls aggression / reaction.

enum Difficulty { EASY, NORMAL, HARD }

@export var difficulty: Difficulty = Difficulty.NORMAL
@export var think_interval: float = 0.12

var character: Character
var input: InputController
var target: Character
var _think_timer: float = 0.0
var _desired_axis: float = 0.0
var _want_jump: bool = false
var _want_dash: bool = false
var _want_light: bool = false
var _want_heavy: bool = false
var _want_block: bool = false
var _want_skill: String = ""
var _rng := RandomNumberGenerator.new()

func setup(char: Character, input_controller: InputController) -> void:
	character = char
	input = input_controller
	input.set_ai_driven()
	_rng.randomize()
	match difficulty:
		Difficulty.EASY:
			think_interval = 0.22
		Difficulty.NORMAL:
			think_interval = 0.12
		Difficulty.HARD:
			think_interval = 0.07

func _physics_process(delta: float) -> void:
	if not character or not input or character.is_dead:
		return
	if target == null or not is_instance_valid(target):
		target = Game.get_opponent(character)
		if target == null:
			return

	_think_timer -= delta
	if _think_timer <= 0.0:
		_think_timer = think_interval * _rng.randf_range(0.8, 1.3)
		_decide()

	_apply_input()

func _decide() -> void:
	_desired_axis = 0.0
	_want_jump = false
	_want_dash = false
	_want_light = false
	_want_heavy = false
	_want_block = false
	_want_skill = ""

	if not character.is_on_floor():
		if _rng.randf() < 0.15:
			_want_light = true
		return

	var to_target := target.global_position - character.global_position
	var dist := absf(to_target.x)
	var facing_sign := signf(to_target.x) if absf(to_target.x) > 1.0 else 0.0

	# Domain / buff first if available and not active
	_try_ai_skill(dist, facing_sign)

	# Block when opponent is attacking nearby
	var threat := false
	if target.state_machine and target.state_machine.current_state_name.begins_with("Attack"):
		if dist < 140.0:
			threat = true

	var block_chance := 0.15
	match difficulty:
		Difficulty.EASY:
			block_chance = 0.1
		Difficulty.NORMAL:
			block_chance = 0.35
		Difficulty.HARD:
			block_chance = 0.55

	if _want_skill == "" and threat and _rng.randf() < block_chance:
		_want_block = true
		return

	# Stay in preferred range
	var preferred := 70.0
	match difficulty:
		Difficulty.EASY:
			preferred = 90.0
		Difficulty.NORMAL:
			preferred = 70.0
		Difficulty.HARD:
			preferred = 60.0

	if dist > preferred + 30.0:
		_desired_axis = facing_sign
		if dist > 220.0 and _rng.randf() < 0.25:
			_want_dash = true
	elif dist < preferred - 20.0:
		_desired_axis = -facing_sign
	else:
		_desired_axis = facing_sign * 0.2
		var attack_chance := 0.35
		match difficulty:
			Difficulty.EASY:
				attack_chance = 0.2
			Difficulty.NORMAL:
				attack_chance = 0.45
			Difficulty.HARD:
				attack_chance = 0.65
		if _want_skill == "" and _rng.randf() < attack_chance:
			if _rng.randf() < 0.7:
				_want_light = true
			else:
				_want_heavy = true

	if _rng.randf() < 0.05:
		_want_jump = true

func _try_ai_skill(dist: float, facing_sign: float) -> void:
	if character.skills == null or character.skills.skills.is_empty():
		return
	if character.energy == null:
		return
	var spirit := character.energy.spirit
	var skill_chance := 0.08
	match difficulty:
		Difficulty.EASY:
			skill_chance = 0.04
		Difficulty.NORMAL:
			skill_chance = 0.12
		Difficulty.HARD:
			skill_chance = 0.2

	# Prefer domain when spirit is high
	if character.skills.skills.has("gui_yu") and spirit >= 40.0 and not character.domain_active:
		if _rng.randf() < skill_chance:
			_want_skill = "gui_yu"
			return
	if character.skills.skills.has("ultimate") and spirit >= 100.0 and dist < 100.0:
		if _rng.randf() < skill_chance * 1.5:
			_want_skill = "ultimate"
			return
	# Offensive skills in range
	if dist < 110.0 and spirit >= 20.0 and _rng.randf() < skill_chance:
		var pool: Array[String] = []
		for id in ["gui_shou", "gui_yan", "burst", "shove", "gui_ying"]:
			if character.skills.skills.has(id):
				var data: SkillData = character.skills.skills[id]
				if character.skills.is_ready(id) and spirit >= data.spirit_cost:
					pool.append(id)
		if pool.size() > 0:
			_want_skill = pool[_rng.randi_range(0, pool.size() - 1)]
	if facing_sign == 0.0 and _want_skill != "":
		pass

func _apply_input() -> void:
	input.move_left = _desired_axis < -0.1
	input.move_right = _desired_axis > 0.1
	input.block_held = _want_block
	if _want_jump:
		input.jump_pressed = true
		_want_jump = false
	if _want_dash:
		input.dash_pressed = true
		_want_dash = false
	if _want_skill != "":
		# Drive skill via manager for correct ids
		character.skills.cast(_want_skill)
		_want_skill = ""
	if _want_light:
		input.attack_light_pressed = true
		_want_light = false
	if _want_heavy:
		input.attack_heavy_pressed = true
		_want_heavy = false
