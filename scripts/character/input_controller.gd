class_name InputController
extends Node
## Player input abstraction so AI can share the same interface.
## Includes a short buffer so presses during recovery still register.

const BUFFER_TIME := 0.12

var move_left: bool = false
var move_right: bool = false
var move_up: bool = false
var move_down: bool = false
var jump_pressed: bool = false
var dash_pressed: bool = false
var attack_light_pressed: bool = false
var attack_heavy_pressed: bool = false
var skill_1_pressed: bool = false
var skill_2_pressed: bool = false
var skill_special_pressed: bool = false
var skill_suppress_pressed: bool = false
var ultimate_pressed: bool = false
var block_held: bool = false
var enabled: bool = true

var _buf_light: float = 0.0
var _buf_heavy: float = 0.0
var _buf_jump: float = 0.0
var _buf_dash: float = 0.0

func _physics_process(delta: float) -> void:
	if not enabled:
		_clear_edge()
		return
	move_left = Input.is_action_pressed("move_left")
	move_right = Input.is_action_pressed("move_right")
	move_up = Input.is_action_pressed("move_up")
	move_down = Input.is_action_pressed("move_down")
	block_held = Input.is_action_pressed("block")

	if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("move_up"):
		_buf_jump = BUFFER_TIME
	if Input.is_action_just_pressed("dash"):
		_buf_dash = BUFFER_TIME
	if Input.is_action_just_pressed("attack_light"):
		_buf_light = BUFFER_TIME
	if Input.is_action_just_pressed("attack_heavy"):
		_buf_heavy = BUFFER_TIME

	_buf_jump = maxf(0.0, _buf_jump - delta)
	_buf_dash = maxf(0.0, _buf_dash - delta)
	_buf_light = maxf(0.0, _buf_light - delta)
	_buf_heavy = maxf(0.0, _buf_heavy - delta)

	jump_pressed = _buf_jump > 0.0
	dash_pressed = _buf_dash > 0.0
	attack_light_pressed = _buf_light > 0.0
	attack_heavy_pressed = _buf_heavy > 0.0
	skill_1_pressed = Input.is_action_just_pressed("skill_1")
	skill_2_pressed = Input.is_action_just_pressed("skill_2")
	skill_special_pressed = Input.is_action_just_pressed("skill_special")
	skill_suppress_pressed = Input.is_action_just_pressed("skill_suppress")
	ultimate_pressed = Input.is_action_just_pressed("ultimate")

func get_move_axis() -> float:
	var axis := 0.0
	if move_left:
		axis -= 1.0
	if move_right:
		axis += 1.0
	return axis

func consume_attack_light() -> void:
	attack_light_pressed = false
	_buf_light = 0.0

func consume_attack_heavy() -> void:
	attack_heavy_pressed = false
	_buf_heavy = 0.0

func consume_jump() -> void:
	jump_pressed = false
	_buf_jump = 0.0

func consume_dash() -> void:
	dash_pressed = false
	_buf_dash = 0.0

func consume_edges() -> void:
	jump_pressed = false
	dash_pressed = false
	attack_light_pressed = false
	attack_heavy_pressed = false
	skill_1_pressed = false
	skill_2_pressed = false
	skill_special_pressed = false
	skill_suppress_pressed = false
	ultimate_pressed = false
	_buf_light = 0.0
	_buf_heavy = 0.0
	_buf_jump = 0.0
	_buf_dash = 0.0

func _clear_edge() -> void:
	jump_pressed = false
	dash_pressed = false
	attack_light_pressed = false
	attack_heavy_pressed = false
	skill_1_pressed = false
	skill_2_pressed = false
	skill_special_pressed = false
	skill_suppress_pressed = false
	ultimate_pressed = false
	move_left = false
	move_right = false
	block_held = false

func set_ai_driven() -> void:
	set_physics_process(false)
	enabled = true
