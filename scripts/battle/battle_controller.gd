class_name BattleController
extends Node2D
## Spawns fighters, wires HUD, handles win/lose, training tools, mode switch.

const CharacterScene := preload("res://scenes/character/character.tscn")

@export var player_stats: CharacterStats
@export var enemy_stats: CharacterStats
@export var use_ai: bool = true
@export var training: bool = true
@export var round_time: float = 99.0

@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var enemy_spawn: Marker2D = $EnemySpawn
@onready var hud: BattleHUD = $HUD

var player: Character
var enemy: Character
var _battle_over: bool = false

func _ready() -> void:
	training = Game.prefer_training
	Game.start_battle(Game.GameMode.TRAINING if training else Game.GameMode.AI_BATTLE)
	_spawn_fighters()
	hud.bind(player, enemy)
	_apply_training_flags()
	if training:
		hud.set_mode_text("TRAINING")
		hud.set_hints("AD移动 J/K攻击 U-I-O-H-P技能 | F5重开 F6无敌 F7无限灵 F8木桩 F9复位 Tab=VS")
	else:
		hud.set_mode_text("VS AI")
		hud.set_hints("J/K攻击 ←格挡 Shift冲刺 U-I-O-H-P技能 | F5重开 Tab=训练")
	if not training:
		hud.start_timer(round_time)
	Game.battle_ended.connect(_on_battle_ended)
	Game.character_died.connect(_on_character_died)
	Debug.dummy_mode_changed.connect(_on_dummy_mode_changed)
	Debug.reset_positions_requested.connect(reset_positions)

func _spawn_fighters() -> void:
	player = CharacterScene.instantiate() as Character
	player.name = "Player"
	player.character_id = 0
	player.team_id = 0
	player.is_player_controlled = true
	player.stats_resource = player_stats
	player.position = player_spawn.position
	add_child(player)

	enemy = CharacterScene.instantiate() as Character
	enemy.name = "Enemy"
	enemy.character_id = 1
	enemy.team_id = 1
	enemy.is_player_controlled = not use_ai
	enemy.stats_resource = enemy_stats
	enemy.position = enemy_spawn.position
	add_child(enemy)

	player.facing = 1
	enemy.facing = -1

func _apply_training_flags() -> void:
	if not training:
		return
	if Debug.dummy_mode:
		_set_dummy_active(true)

func _process(_delta: float) -> void:
	if not training and not _battle_over:
		if hud._time_left <= 0.0:
			_end_by_timeout()

func _end_by_timeout() -> void:
	if _battle_over:
		return
	_battle_over = true
	hud.stop_timer()
	var winner := Game.decide_timeout_winner()
	var text := "DRAW"
	if winner == 0:
		text = "YOU WIN (TIME)"
	elif winner == 1:
		text = "YOU LOSE (TIME)"
	hud.set_result(text)
	Game.battle_active = false
	await get_tree().create_timer(2.5).timeout
	Game.restart_battle()

func reset_positions() -> void:
	if not is_instance_valid(player) or not is_instance_valid(enemy):
		return
	player.reset_for_training(player_spawn.position)
	enemy.reset_for_training(enemy_spawn.position)
	player.facing = 1
	enemy.facing = -1
	if not training:
		# In VS, only reset positions/HP if both alive; keep round going
		pass
	hud.set_result("")

func _on_dummy_mode_changed(active: bool) -> void:
	if training and is_instance_valid(enemy):
		_set_dummy_active(active)

func _set_dummy_active(active: bool) -> void:
	if enemy == null:
		return
	if enemy.ai:
		enemy.ai.set_physics_process(not active)
	if enemy.input_ctrl:
		if active:
			enemy.input_ctrl.set_ai_driven()
			enemy.input_ctrl.consume_edges()
			enemy.input_ctrl.move_left = false
			enemy.input_ctrl.move_right = false
			enemy.input_ctrl.block_held = false
		elif enemy.ai:
			enemy.input_ctrl.set_ai_driven()
	if active:
		enemy.velocity.x = 0.0
		# Stand still in Idle
		if enemy.state_machine and not enemy.is_dead:
			enemy.state_machine.force_change("Idle")
	hud.set_mode_text("TRAINING · DUMMY" if active else "TRAINING")

func _on_character_died(_id: int) -> void:
	if training:
		await get_tree().create_timer(1.0).timeout
		if _battle_over:
			return
		reset_positions()
		if Debug.dummy_mode:
			_set_dummy_active(true)
		return
	# versus: Game._check_battle_end on death

func _on_battle_ended(winner_id: int) -> void:
	if training or _battle_over:
		return
	_battle_over = true
	var text := "DRAW"
	if winner_id == 0:
		text = "YOU WIN"
	elif winner_id == 1:
		text = "YOU LOSE"
	hud.set_result(text + "\nF5 再战 · Tab 回训练")
	hud.stop_timer()
	await get_tree().create_timer(2.5).timeout
	if not _battle_over:
		return
	# Auto rematch
	Game.restart_battle()
