extends Node

signal experience_collected(amount: int)

func emit_experience_collected(amount: int) -> void:
	experience_collected.emit(amount)
