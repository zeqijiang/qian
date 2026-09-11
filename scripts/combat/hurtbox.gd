class_name Hurtbox
extends Area2D
## Receives hits from Hitboxes.

signal hurt_received(damage_info: DamageInfo, attacker: Character)

var owner_character: Character
var _debug_rect: ColorRect

@onready var _collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	add_to_group("hurtbox")
	monitoring = false
	monitorable = true
	collision_layer = GameConstants.LAYER_HURTBOX
	collision_mask = GameConstants.LAYER_HITBOX
	_setup_debug()

func _setup_debug() -> void:
	_debug_rect = ColorRect.new()
	_debug_rect.color = Color(0.2, 1.0, 0.4, 0.28)
	_debug_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_debug_rect.visible = Debug.show_hurtbox
	if _collision.shape is RectangleShape2D:
		var rs := _collision.shape as RectangleShape2D
		_debug_rect.size = rs.size
		_debug_rect.position = -rs.size * 0.5 + _collision.position
	elif _collision.shape is CapsuleShape2D:
		var cs := _collision.shape as CapsuleShape2D
		_debug_rect.size = Vector2(cs.radius * 2.0, cs.height)
		_debug_rect.position = -_debug_rect.size * 0.5 + _collision.position
	add_child(_debug_rect)

func set_debug_visible(v: bool) -> void:
	if _debug_rect:
		_debug_rect.visible = v

func receive_hit(info: DamageInfo, attacker: Character) -> void:
	if not owner_character or not info:
		return
	if owner_character.is_dead or owner_character.invulnerable:
		return
	owner_character.on_hit_received(info, attacker)
	hurt_received.emit(info, attacker)
