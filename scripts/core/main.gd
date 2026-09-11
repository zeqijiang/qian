extends Node2D
## Main entry. Starts training battle directly for prototype.

func _ready() -> void:
	Game.training_mode = true
	# Defer so we don't mutate the scene tree during node setup.
	get_tree().change_scene_to_file.call_deferred("res://scenes/battle/battle.tscn")

