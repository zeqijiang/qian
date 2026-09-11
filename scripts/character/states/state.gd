class_name State
extends Node
## Base class for all character states.

var character: Character
var state_machine: CharacterStateMachine
var state_time: float = 0.0

func enter() -> void:
	state_time = 0.0

func exit() -> void:
	pass

func process(delta: float) -> void:
	state_time += delta

func physics_process(delta: float) -> void:
	pass

func handle_input(_input: Dictionary) -> void:
	pass

func can_cancel_to(_state_name: String) -> bool:
	return false

func get_state_name() -> String:
	return name

func is_airborne_state() -> bool:
	return false
