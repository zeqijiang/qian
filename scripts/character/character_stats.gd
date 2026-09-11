class_name CharacterStats
extends Resource
## Data-driven character stats. Keep numbers out of combat logic.

@export var character_name: String = "Unknown"
@export var display_name: String = "未知"
@export var max_hp: float = 1000.0
@export var attack: float = 1.0
@export var defense: float = 1.0
@export var move_speed: float = 280.0
@export var jump_velocity: float = -620.0
@export var dash_speed: float = 520.0
@export var dash_duration: float = 0.18
@export var gravity_scale: float = 1.0
@export var air_control: float = 0.65

@export_group("灵异系统")
@export var max_spirit: float = 100.0
@export var max_revival: float = 100.0
@export var spirit_gain_on_hit: float = 8.0
@export var spirit_gain_on_hurt: float = 5.0
@export var revival_gain_on_cast: float = 6.0
@export var revival_gain_on_hurt: float = 3.0
@export var revival_passive_rate: float = 0.8

@export_group("外观占位")
@export var body_color: Color = Color(0.25, 0.45, 0.95)
@export var accent_color: Color = Color(0.7, 0.85, 1.0)
@export var body_width: float = 48.0
@export var body_height: float = 96.0

func clone() -> CharacterStats:
	return duplicate(true) as CharacterStats
