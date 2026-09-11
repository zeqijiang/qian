extends Node
## Debug / training overlay manager (autoload: Debug)

var show_hitbox: bool = false
var show_hurtbox: bool = false
var show_state: bool = false
var show_fps: bool = false
var invincible: bool = false
var infinite_energy: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_toggle_hitbox"):
		show_hitbox = not show_hitbox
		_refresh_hitboxes()
	elif event.is_action_pressed("debug_toggle_hurtbox"):
		show_hurtbox = not show_hurtbox
		_refresh_hurtboxes()
	elif event.is_action_pressed("debug_toggle_state"):
		show_state = not show_state
	elif event.is_action_pressed("debug_toggle_fps"):
		show_fps = not show_fps
	elif event.is_action_pressed("debug_toggle_invincible"):
		invincible = not invincible
	elif event.is_action_pressed("debug_infinite_energy"):
		infinite_energy = not infinite_energy
	elif event.is_action_pressed("debug_reset"):
		Game.restart_battle()

func _refresh_hitboxes() -> void:
	for hb in get_tree().get_nodes_in_group("hitbox"):
		if hb.has_method("set_debug_visible"):
			hb.set_debug_visible(show_hitbox)

func _refresh_hurtboxes() -> void:
	for hb in get_tree().get_nodes_in_group("hurtbox"):
		if hb.has_method("set_debug_visible"):
			hb.set_debug_visible(show_hurtbox)
