class_name AttackLightState
extends AttackState

func enter() -> void:
	if profile.is_empty():
		configure({
			"name": "light",
			"startup": 0.04,
			"active": 0.07,
			"recovery": 0.09,
			"cancel_window": 0.16,
			"damage": 20.0,
			"hitstun": 0.15,
			"knockback": 90.0,
			"reach": 58.0,
			"spirit_gain": 8.0,
		})
	super.enter()
