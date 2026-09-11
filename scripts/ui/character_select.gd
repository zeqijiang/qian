class_name CharacterSelect
extends Control
## Pick player fighter and opponent, then start battle.

var _player_idx: int = 0
var _enemy_idx: int = 0
var _roster: Array[String] = []
var _enemies: Array[String] = []

@onready var _title: Label = $Root/Title
@onready var _mode_label: Label = $Root/ModeLabel
@onready var _p_name: Label = $Root/PName
@onready var _p_blurb: Label = $Root/PBlurb
@onready var _p_color: ColorRect = $Root/PColor
@onready var _e_name: Label = $Root/EName
@onready var _e_blurb: Label = $Root/EBlurb
@onready var _e_color: ColorRect = $Root/EColor
@onready var _hint: Label = $Root/Hint
@onready var _btn_p_prev: Button = $Root/BtnPPrev
@onready var _btn_p_next: Button = $Root/BtnPNext
@onready var _btn_e_prev: Button = $Root/BtnEPrev
@onready var _btn_e_next: Button = $Root/BtnENext
@onready var _btn_start: Button = $Root/BtnStart
@onready var _btn_back: Button = $Root/BtnBack

func _ready() -> void:
	_roster = CharacterRegistry.playable_ids()
	_enemies = ["placeholder_enemy", "yangjian", "ye_zhen"]
	_mode_label.text = "训练场" if Game.prefer_training else "VS AI"
	_title.text = "选择角色"
	_hint.text = "A/D 换角色 · Enter 开始 · Esc 返回"
	_btn_p_prev.pressed.connect(func() -> void: _cycle_player(-1))
	_btn_p_next.pressed.connect(func() -> void: _cycle_player(1))
	_btn_e_prev.pressed.connect(func() -> void: _cycle_enemy(-1))
	_btn_e_next.pressed.connect(func() -> void: _cycle_enemy(1))
	_btn_start.pressed.connect(_start)
	_btn_back.pressed.connect(func() -> void:
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	)
	_refresh()
	_btn_start.grab_focus()

func _cycle_player(d: int) -> void:
	_player_idx = wrapi(_player_idx + d, 0, _roster.size())
	_refresh()

func _cycle_enemy(d: int) -> void:
	_enemy_idx = wrapi(_enemy_idx + d, 0, _enemies.size())
	_refresh()

func _refresh() -> void:
	var pid: String = _roster[_player_idx]
	var eid: String = _enemies[_enemy_idx]
	_p_name.text = CharacterRegistry.display_name(pid)
	_p_blurb.text = CharacterRegistry.blurb(pid)
	_p_color.color = CharacterRegistry.color(pid)
	_e_name.text = CharacterRegistry.display_name(eid)
	_e_blurb.text = CharacterRegistry.blurb(eid)
	_e_color.color = CharacterRegistry.color(eid)
	if Game.prefer_training:
		_mode_label.text = "训练场 · 对手=%s" % CharacterRegistry.display_name(eid)
	else:
		_mode_label.text = "VS AI · 对手=%s" % CharacterRegistry.display_name(eid)

func _start() -> void:
	Game.selected_player_id = _roster[_player_idx]
	Game.selected_enemy_id = _enemies[_enemy_idx]
	get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_start()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("move_left"):
		if event is InputEventKey:
			_cycle_player(-1)
	elif event.is_action_pressed("move_right"):
		if event is InputEventKey:
			_cycle_player(1)
