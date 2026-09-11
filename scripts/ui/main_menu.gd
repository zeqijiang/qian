class_name MainMenu
extends Control
## Title screen: Training / VS / Quit.

@onready var _title: Label = $Center/VBox/Title
@onready var _sub: Label = $Center/VBox/Sub
@onready var _btn_train: Button = $Center/VBox/BtnTraining
@onready var _btn_vs: Button = $Center/VBox/BtnVS
@onready var _btn_quit: Button = $Center/VBox/BtnQuit

func _ready() -> void:
	_title.text = "神秘复苏：灵异格斗"
	_sub.text = "可玩原型 · Phase 0-1"
	_btn_train.pressed.connect(func() -> void:
		Game.prefer_training = true
		Game.selected_enemy_id = "placeholder_enemy"
		get_tree().change_scene_to_file("res://scenes/ui/character_select.tscn")
	)
	_btn_vs.pressed.connect(func() -> void:
		Game.prefer_training = false
		get_tree().change_scene_to_file("res://scenes/ui/character_select.tscn")
	)
	_btn_quit.pressed.connect(func() -> void:
		get_tree().quit()
	)
	_btn_train.grab_focus()
