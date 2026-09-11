class_name Hitbox
extends Area2D
## Active attack region. One-way: only hurts Hurtboxes.

signal hit_landed(hurtbox: Hurtbox, damage_info: DamageInfo)

var owner_character: Character
var damage_info: DamageInfo
var _has_hit_this_activation: bool = false
var _debug_rect: ColorRect

@onready var _collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	add_to_group("hitbox")
	monitoring = false
	monitorable = false
	collision_layer = GameConstants.LAYER_HITBOX
	collision_mask = GameConstants.LAYER_HURTBOX
	area_entered.connect(_on_area_entered)
	_setup_debug()

func _setup_debug() -> void:
	_debug_rect = ColorRect.new()
	_debug_rect.color = Color(1.0, 0.2, 0.2, 0.35)
	_debug_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_debug_rect.visible = Debug.show_hitbox
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

func activate(info: DamageInfo) -> void:
	damage_info = info
	_has_hit_this_activation = false
	monitoring = true
	visible = true
	if _debug_rect:
		_debug_rect.visible = Debug.show_hitbox

func deactivate() -> void:
	monitoring = false
	if _debug_rect and not Debug.show_hitbox:
		_debug_rect.visible = false

func is_active() -> bool:
	return monitoring

func _on_area_entered(area: Area2D) -> void:
	if not monitoring or _has_hit_this_activation:
		return
	if area is Hurtbox:
		var hurt: Hurtbox = area
		if hurt.owner_character == owner_character:
			return
		if owner_character and owner_character.team_id == hurt.owner_character.team_id:
			return
		_has_hit_this_activation = true
		hurt.receive_hit(damage_info, owner_character)
		hit_landed.emit(hurt, damage_info)

func set_reach(width: float) -> void:
	if _collision.shape is RectangleShape2D:
		var rs := _collision.shape.duplicate() as RectangleShape2D
		rs.size.x = width
		_collision.shape = rs
		if _debug_rect:
			_debug_rect.size = rs.size
			_debug_rect.position = -rs.size * 0.5 + _collision.position
