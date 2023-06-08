extends Node

signal experience_collected(amount: int)
signal health_updated(current_health: float, max_health: float)

func emit_experience_collected(amount: int) -> void:
	experience_collected.emit(amount)

func emit_health_updated(current_health: float, max_health: float) -> void:
	health_updated.emit(current_health, max_health)
