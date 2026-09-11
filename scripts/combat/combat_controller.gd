class_name CombatController
extends Node
## Orchestrates hitbox activation, damage application, combo counting.

var character: Character
var hitbox: Hitbox
var combo: ComboManager
var energy: EnergyManager
var _current_profile: Dictionary = {}
var _current_damage: DamageInfo

func setup(char: Character) -> void:
	character = char
	combo = ComboManager.new()
	add_child(combo)
	energy = EnergyManager.new()
	add_child(energy)
	energy.setup(character)

func bind_hitbox(hb: Hitbox) -> void:
	hitbox = hb
	hitbox.owner_character = character
	hitbox.hit_landed.connect(_on_hit_landed)

func start_attack(profile: Dictionary) -> void:
	_current_profile = profile
	_current_damage = DamageInfo.new()
	_current_damage.base_damage = float(profile.get("damage", 20.0))
	_current_damage.hitstun = float(profile.get("hitstun", 0.15))
	_current_damage.blockstun = float(profile.get("blockstun", 0.1))
	_current_damage.knockback = float(profile.get("knockback", 120.0))
	_current_damage.launch = bool(profile.get("launch", false))
	_current_damage.launch_velocity = float(profile.get("launch_velocity", -420.0))
	_current_damage.attack_name = str(profile.get("name", "attack"))
	_current_damage.unblockable = bool(profile.get("unblockable", false))
	if character and character.stats:
		_current_damage.skill_multiplier = character.stats.attack
		if character.energy and character.energy.revival_active:
			_current_damage.skill_multiplier *= 1.15

func get_current_damage_info() -> DamageInfo:
	return _current_damage

func activate_hitbox() -> void:
	if not hitbox or not _current_damage:
		return
	var reach := float(_current_profile.get("reach", 56.0))
	hitbox.set_reach(reach)
	if character:
		var col: CollisionShape2D = hitbox.get_node_or_null("CollisionShape2D")
		if col:
			col.position.x = absf(col.position.x) * float(character.facing)
		hitbox.position.x = 0.0
	hitbox.activate(_current_damage)

func deactivate_hitbox() -> void:
	if hitbox:
		hitbox.deactivate()

func end_attack() -> void:
	deactivate_hitbox()
	_current_profile = {}

func _on_hit_landed(_hurtbox: Hurtbox, info: DamageInfo) -> void:
	if not info or not character:
		return
	combo.register_hit(info.attack_name, info.base_damage)
	if energy:
		energy.add_spirit(character.stats.spirit_gain_on_hit)
	character.on_landed_hit(info)
