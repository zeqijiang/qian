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

	if not character.is_on_floor():
		if _rng.randf() < 0.15:
			_want_light = true
		return

	var to_target := target.global_position - character.global_position
	var dist := absf(to_target.x)
	var facing_sign := signf(to_target.x) if absf(to_target.x) > 1.0 else 0.0

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

	if threat and _rng.randf() < block_chance:
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
		if _rng.randf() < attack_chance:
			if _rng.randf() < 0.7:
				_want_light = true
			else:
				_want_heavy = true

	if _rng.randf() < 0.05:
		_want_jump = true

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
	if _want_light:
		input.attack_light_pressed = true
		_want_light = false
	if _want_heavy:
		input.attack_heavy_pressed = true
		_want_heavy = false
