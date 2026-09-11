class_name AttackHeavyState
extends AttackState

func enter() -> void:
	if profile.is_empty():
		configure({
			"name": "heavy",
			"startup": 0.14,
			"active": 0.1,
			"recovery": 0.28,
			"cancel_window": 0.08,
			"damage": 50.0,
			"hitstun": 0.35,
			"knockback": 220.0,
			"launch": true,
			"launch_velocity": -480.0,
			"reach": 70.0,
			"spirit_gain": 12.0,
		})
	super.enter()
