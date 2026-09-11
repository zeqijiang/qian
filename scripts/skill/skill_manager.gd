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

func _process(delta: float) -> void:
	for id in cooldowns:
		if cooldowns[id] > 0.0:
			cooldowns[id] = maxf(0.0, cooldowns[id] - delta)

func can_cast(skill_id: String) -> bool:
	if not skills.has(skill_id):
		return false
	if cooldowns.get(skill_id, 0.0) > 0.0:
		return false
	var data: SkillData = skills[skill_id]
	if character and character.energy and not Debug.infinite_energy:
		if character.energy.spirit < data.spirit_cost:
			return false
	return true

func cast(skill_id: String) -> bool:
	if not can_cast(skill_id):
		return false
	var data: SkillData = skills[skill_id]
	cooldowns[skill_id] = data.cooldown
	if character and character.state_machine:
		var st = character.state_machine.states.get("Skill")
		if st is SkillState:
			st.configure(data.to_profile())
			character.state_machine.force_change("Skill")
			return true
	return false
