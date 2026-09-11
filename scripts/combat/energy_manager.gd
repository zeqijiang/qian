class_name EnergyManager
extends Node
## Spirit (lingyi) + Revival (fugui) energy systems.

signal spirit_changed(current: float, max_value: float)
signal revival_changed(current: float, max_value: float)
signal revival_triggered
signal spirit_depleted

var spirit: float = 50.0
var max_spirit: float = GameConstants.MAX_SPIRIT
var revival: float = 0.0
var max_revival: float = GameConstants.MAX_REVIVAL
var revival_threshold: float = GameConstants.REVIVAL_THRESHOLD
var revival_active: bool = false
var spirit_regen_rate: float = 4.0
var revival_passive_rate: float = 0.8
var _owner_char: Node

func setup(character) -> void:
	_owner_char = character
	if character != null and character.get("stats") != null:
		var st = character.stats
		max_spirit = st.max_spirit
		max_revival = st.max_revival
		spirit_regen_rate = 4.0
		revival_passive_rate = st.revival_passive_rate
	spirit = max_spirit * 0.5
	revival = 0.0
	spirit_changed.emit(spirit, max_spirit)
	revival_changed.emit(revival, max_revival)

func _process(delta: float) -> void:
	if Debug.infinite_energy:
		spirit = max_spirit
		spirit_changed.emit(spirit, max_spirit)
		return
	if spirit < max_spirit:
		spirit = minf(max_spirit, spirit + spirit_regen_rate * delta)
		spirit_changed.emit(spirit, max_spirit)
	if not revival_active and revival < max_revival:
		revival = minf(max_revival, revival + revival_passive_rate * delta)
		revival_changed.emit(revival, max_revival)
		_check_revival_threshold()

func add_spirit(amount: float) -> void:
	if Debug.infinite_energy:
		return
	spirit = clampf(spirit + amount, 0.0, max_spirit)
	spirit_changed.emit(spirit, max_spirit)

func spend_spirit(amount: float) -> bool:
	if Debug.infinite_energy:
		return true
	if spirit < amount:
		spirit_depleted.emit()
		return false
	spirit -= amount
	spirit_changed.emit(spirit, max_spirit)
	return true

func add_revival(amount: float) -> void:
	if revival_active:
		return
	revival = clampf(revival + amount, 0.0, max_revival)
	revival_changed.emit(revival, max_revival)
	_check_revival_threshold()

func _check_revival_threshold() -> void:
	if not revival_active and revival >= revival_threshold:
		revival_active = true
		revival_triggered.emit()

func reset() -> void:
	spirit = max_spirit * 0.5
	revival = 0.0
	revival_active = false
	spirit_changed.emit(spirit, max_spirit)
	revival_changed.emit(revival, max_revival)

func set_training_infinite() -> void:
	spirit = max_spirit
	revival = 0.0
	spirit_changed.emit(spirit, max_spirit)
	revival_changed.emit(revival, max_revival)
