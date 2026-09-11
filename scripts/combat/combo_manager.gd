class_name ComboManager
extends Node
## Tracks combo count / damage / timer.

signal combo_updated(count: int, damage: float)
signal combo_dropped(count: int, damage: float)

var combo_count: int = 0
var combo_damage: float = 0.0
var combo_timer: float = 0.0
var last_attack_name: String = ""
var combo_window: float = GameConstants.DEFAULT_COMBO_WINDOW
var max_combo_count: int = 0
var max_combo_damage: float = 0.0

func _process(delta: float) -> void:
	if combo_count > 0:
		combo_timer -= delta
		if combo_timer <= 0.0:
			drop_combo()

func register_hit(attack_name: String, damage: float) -> void:
	combo_count += 1
	combo_damage += damage
	combo_timer = combo_window
	last_attack_name = attack_name
	if combo_count > max_combo_count:
		max_combo_count = combo_count
	if combo_damage > max_combo_damage:
		max_combo_damage = combo_damage
	combo_updated.emit(combo_count, combo_damage)

func drop_combo() -> void:
	if combo_count > 0:
		combo_dropped.emit(combo_count, combo_damage)
	combo_count = 0
	combo_damage = 0.0
	combo_timer = 0.0
	last_attack_name = ""
	combo_updated.emit(0, 0.0)

func reset() -> void:
	drop_combo()
	max_combo_count = 0
	max_combo_damage = 0.0
