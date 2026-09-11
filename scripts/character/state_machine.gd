class_name CharacterStateMachine
extends Node
## Finite state machine for Character.

signal state_changed(old_state: String, new_state: String)

@export var initial_state: NodePath

var states: Dictionary = {}
var current_state: State = null
var current_state_name: String = ""
var character: Character
var locked: bool = false

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.state_machine = self

func setup(char: Character) -> void:
	character = char
	for state_name in states:
		var s: State = states[state_name]
		s.character = character

func start() -> void:
	var start_name := "Idle"
	if not initial_state.is_empty():
		var node := get_node_or_null(initial_state)
		if node is State:
			start_name = node.name
	if states.has(start_name):
		_force_change(start_name)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)
		current_state.process(delta)

func change_state(state_name: String) -> bool:
	if locked or not states.has(state_name):
		return false
	if current_state_name == state_name:
		return false
	if current_state and not current_state.can_cancel_to(state_name):
		return false
	_force_change(state_name)
	return true

func force_change(state_name: String) -> void:
	if states.has(state_name):
		_force_change(state_name)

func _force_change(state_name: String) -> void:
	var old := current_state_name
	if current_state:
		current_state.exit()
	current_state = states[state_name]
	current_state_name = state_name
	current_state.enter()
	state_changed.emit(old, state_name)
	if character:
		character.on_state_changed(old, state_name)

func is_state(state_name: String) -> bool:
	return current_state_name == state_name

func get_current() -> State:
	return current_state

func lock() -> void:
	locked = true

func unlock() -> void:
	locked = false
