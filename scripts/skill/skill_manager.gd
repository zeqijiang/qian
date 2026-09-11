class_name SkillManager
extends Node
## Holds skills and handles cast requests / cooldowns.

var character: Character
var skills: Dictionary = {}
var cooldowns: Dictionary = {}

func setup(char: Character) -> void:
	character = char

func register_skill(data: SkillData) -> void:
	if data and data.skill_id != "":
		skills[data.skill_id] = data
		cooldowns[data.skill_id] = 0.0

func load_kit_for_character(character_name: String) -> void:
	match character_name:
		"yangjian":
			for s in YangJianKit.build_skills():
				register_skill(s)
		"ye_zhen":
			for s in YeZhenKit.build_skills():
				register_skill(s)
		"placeholder_enemy":
			for s in PlaceholderKit.build_skills():
				register_skill(s)

func _process(delta: float) -> void:
	for id in cooldowns:
		if cooldowns[id] > 0.0:
			cooldowns[id] = maxf(0.0, cooldowns[id] - delta)

func get_skill(skill_id: String) -> SkillData:
	return skills.get(skill_id) as SkillData

func is_ready(skill_id: String) -> bool:
	return cooldowns.get(skill_id, 0.0) <= 0.0

func get_cooldown_ratio(skill_id: String) -> float:
	var data := get_skill(skill_id)
	if data == null or data.cooldown <= 0.0:
		return 0.0
	return clampf(cooldowns.get(skill_id, 0.0) / data.cooldown, 0.0, 1.0)

func can_cast(skill_id: String) -> bool:
	if not skills.has(skill_id):
		return false
	if cooldowns.get(skill_id, 0.0) > 0.0:
		return false
	if character == null or character.is_dead:
		return false
	# Skills need a castable state
	var st := character.get_state_name()
	if st in ["Hit", "AirHit", "Knockdown", "GetUp", "Dead", "Skill"]:
		return false
	var data: SkillData = skills[skill_id]
	if character.energy and not Debug.infinite_energy:
		if character.energy.spirit < data.spirit_cost:
			return false
	return true

func cast(skill_id: String) -> bool:
	if not can_cast(skill_id):
		return false
	var data: SkillData = skills[skill_id]
	var st = character.state_machine.states.get("Skill")
	if st is SkillState:
		st.configure(data.to_profile())
		character.state_machine.force_change("Skill")
		return true
	return false

func try_cast_from_input() -> bool:
	if character == null or character.input_ctrl == null:
		return false
	var ic := character.input_ctrl
	if ic.ultimate_pressed:
		ic.ultimate_pressed = false
		return cast("ultimate")
	if ic.skill_special_pressed:
		ic.skill_special_pressed = false
		if skills.has("gui_yu"):
			return cast("gui_yu")
		if skills.has("tie_bi"):
			return cast("tie_bi")
	if ic.skill_suppress_pressed:
		ic.skill_suppress_pressed = false
		if skills.has("gui_yan"):
			return cast("gui_yan")
		if skills.has("ba_ti"):
			return cast("ba_ti")
	if ic.skill_2_pressed:
		ic.skill_2_pressed = false
		if skills.has("gui_ying"):
			return cast("gui_ying")
		if skills.has("beng_quan"):
			return cast("beng_quan")
	if ic.skill_1_pressed:
		ic.skill_1_pressed = false
		if skills.has("gui_shou"):
			return cast("gui_shou")
		if skills.has("tie_chong"):
			return cast("tie_chong")
	return false
