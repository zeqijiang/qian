class_name AttackHeavyState
extends AttackState

func enter() -> void:
	if profile.is_empty():
		configure({
			"name": "heavy",
			"startup": 0.09,
			"active": 0.09,
			"recovery": 0.16,
			"cancel_window": 0.10,
			"damage": 50.0,
			"hitstun": 0.32,
			"knockback": 210.0,
			"launch": true,
			"launch_velocity": -480.0,
			"reach": 72.0,
			"spirit_gain": 12.0,
		})
	super.enter()
