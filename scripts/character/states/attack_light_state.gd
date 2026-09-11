class_name AttackLightState
extends AttackState

func enter() -> void:
	if profile.is_empty():
		configure({
			"name": "light",
			"startup": 0.06,
			"active": 0.08,
			"recovery": 0.14,
			"cancel_window": 0.12,
			"damage": 20.0,
			"hitstun": 0.15,
			"knockback": 90.0,
			"reach": 56.0,
			"spirit_gain": 8.0,
		})
	super.enter()
