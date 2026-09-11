class_name BattleController
extends Node2D
## Spawns fighters, wires HUD, handles win/lose and restart.

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

func _ready() -> void:
	Game.start_battle(Game.GameMode.TRAINING if training else Game.GameMode.AI_BATTLE)
	_spawn_fighters()
	hud.bind(player, enemy)
	if training:
		hud.set_mode_text("TRAINING")
		hud.set_hints("AD移动 W跳 Shift冲刺 J轻K重 ←格挡 | U鬼手 I鬼影 O鬼域 H压制 P奥义 | F7无限灵异")
	else:
		hud.set_mode_text("VS AI")
		hud.set_hints("J轻 K重 ←格挡 Shift冲刺 | U/I/O/H/P 技能 | F5重置")
	if not training:
		hud.start_timer(round_time)
	Game.battle_ended.connect(_on_battle_ended)
	Game.character_died.connect(_on_character_died)

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

	# Face each other
	player.facing = 1
	enemy.facing = -1

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart") or Input.is_action_just_pressed("debug_reset"):
		Game.restart_battle()

func _on_character_died(_id: int) -> void:
	if training:
		# Auto reset after short delay
		await get_tree().create_timer(1.2).timeout
		if is_instance_valid(player):
			player.reset_for_training(player_spawn.position)
		if is_instance_valid(enemy):
			enemy.reset_for_training(enemy_spawn.position)
		hud.set_result("")
		return
	# versus handled by Game._check_battle_end

func _on_battle_ended(winner_id: int) -> void:
	if training:
		return
	var text := "DRAW"
	if winner_id == 0:
		text = "YOU WIN"
	elif winner_id == 1:
		text = "YOU LOSE"
	hud.set_result(text)
	hud.stop_timer()
	await get_tree().create_timer(2.5).timeout
	Game.restart_battle()
