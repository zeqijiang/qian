extends Node
## Global game manager (autoload: Game)

signal battle_started
signal battle_ended(winner_id: int)
signal character_died(character_id: int)

enum GameMode { TRAINING, VERSUS, AI_BATTLE, SURVIVAL }
enum Difficulty { EASY, NORMAL, HARD }

var current_mode: GameMode = GameMode.TRAINING
var current_difficulty: Difficulty = Difficulty.NORMAL
var training_mode: bool = true
var battle_active: bool = false
var characters: Array[Node] = []
var stage_bounds: Rect2 = Rect2(-640, -360, 1280, 720)
var ground_y: float = 280.0

func start_battle(mode: GameMode = GameMode.TRAINING) -> void:
	current_mode = mode
	training_mode = mode == GameMode.TRAINING
	battle_active = true
	characters.clear()
	battle_started.emit()

func end_battle(winner_id: int = -1) -> void:
	battle_active = false
	battle_ended.emit(winner_id)

func register_character(character: Node) -> void:
	if character not in characters:
		characters.append(character)

func unregister_character(character: Node) -> void:
	characters.erase(character)

func get_opponent(character: Node) -> Node:
	for c in characters:
		if c != character:
			return c
	return null

func notify_death(character_id: int) -> void:
	character_died.emit(character_id)
	if battle_active:
		_check_battle_end()

func _check_battle_end() -> void:
	var alive: Array[Node] = []
	for c in characters:
		if is_instance_valid(c) and not c.is_dead:
			alive.append(c)
	if alive.size() == 1 and characters.size() >= 2:
		end_battle(alive[0].character_id)
	elif alive.size() == 0:
		end_battle(-1)

func restart_battle() -> void:
	get_tree().reload_current_scene()
