class_name InputController
extends Node
## Player input abstraction so AI can share the same interface.

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
var ultimate_pressed: bool = false
var block_held: bool = false
var enabled: bool = true

func _physics_process(_delta: float) -> void:
	if not enabled:
		_clear_edge()
		return
	move_left = Input.is_action_pressed("move_left")
	move_right = Input.is_action_pressed("move_right")
	move_up = Input.is_action_pressed("move_up")
	move_down = Input.is_action_pressed("move_down")
	block_held = Input.is_action_pressed("block")
	jump_pressed = Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("move_up")
	dash_pressed = Input.is_action_just_pressed("dash")
	attack_light_pressed = Input.is_action_just_pressed("attack_light")
	attack_heavy_pressed = Input.is_action_just_pressed("attack_heavy")
	skill_1_pressed = Input.is_action_just_pressed("skill_1")
	skill_2_pressed = Input.is_action_just_pressed("skill_2")
	skill_special_pressed = Input.is_action_just_pressed("skill_special")
	ultimate_pressed = Input.is_action_just_pressed("ultimate")

func get_move_axis() -> float:
	var axis := 0.0
	if move_left:
		axis -= 1.0
	if move_right:
		axis += 1.0
	return axis

func consume_edges() -> void:
	jump_pressed = false
	dash_pressed = false
	attack_light_pressed = false
	attack_heavy_pressed = false
	skill_1_pressed = false
	skill_2_pressed = false
	skill_special_pressed = false
	ultimate_pressed = false

func _clear_edge() -> void:
	jump_pressed = false
	dash_pressed = false
	attack_light_pressed = false
	attack_heavy_pressed = false
	skill_1_pressed = false
	skill_2_pressed = false
	skill_special_pressed = false
	ultimate_pressed = false
	move_left = false
	move_right = false
	block_held = false

func set_ai_driven() -> void:
	set_physics_process(false)
	enabled = true
