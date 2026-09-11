extends Node
## Global game manager (autoload: Game)

signal battle_started
signal battle_ended(winner_id: int)
signal character_died(character_id: int)
signal mode_changed(training: bool)

enum GameMode { TRAINING, VERSUS, AI_BATTLE, SURVIVAL }
enum Difficulty { EASY, NORMAL, HARD }

var current_mode: GameMode = GameMode.TRAINING
var current_difficulty: Difficulty = Difficulty.NORMAL
var training_mode: bool = true
var prefer_training: bool = true
var battle_active: bool = false
var characters: Array[Node] = []
var stage_bounds: Rect2 = Rect2(-640, -360, 1280, 720)
var ground_y: float = 280.0

func start_battle(mode: GameMode = GameMode.TRAINING) -> void:
	current_mode = mode
	training_mode = mode == GameMode.TRAINING
	prefer_training = training_mode
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
	if battle_active and not training_mode:
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

func decide_timeout_winner() -> int:
	var best_id := -1
	var best_hp := -1.0
	for c in characters:
		if not is_instance_valid(c):
			continue
		var ch := c as Character
		if ch == null:
			continue
		if ch.is_dead:
			continue
		if ch.hp > best_hp:
			best_hp = ch.hp
			best_id = ch.character_id
		elif is_equal_approx(ch.hp, best_hp):
			best_id = -1
	return best_id

func toggle_prefer_training() -> void:
	prefer_training = not prefer_training
	mode_changed.emit(prefer_training)
	restart_battle()

func restart_battle() -> void:
	get_tree().reload_current_scene()
