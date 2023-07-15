extends Node

signal experience_updated(current_experience: int, target_experience: int)
signal level_up(new_level: int)

var current_experience: int = 0
var target_experience := get_target_experience(current_level + 1)
var current_level: int = 1


func _ready() -> void:
	GameEvents.experience_collected.connect(on_experience_collected)


func on_experience_collected(amount: int) -> void:
	increment_experience(amount)


func get_target_experience(level: int) -> int:
	return round(pow(level, 1.5) + level * 4)


# TODO: Account for multiple levele ups within one amount
func increment_experience(amount: int) -> void:
	current_experience = min(current_experience + amount, target_experience)
	experience_updated.emit(current_experience, target_experience)
	if current_experience == target_experience:
		GameEvents.emit_sound_made("level_up", -15.0, 1.3)
		current_level += 1
		target_experience = get_target_experience(current_level + 1)
		current_experience = 0
		experience_updated.emit(current_experience, target_experience)
		level_up.emit(current_level)
