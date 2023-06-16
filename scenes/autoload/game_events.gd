extends Node

signal experience_collected(amount: int)
signal money_collected(amount: int)
signal money_spent(amount: int)
signal health_damaged(current_health: float, max_health: float)
signal health_healed(current_health: float, max_health: float)
signal buff_added(buff: Buff, current_buffs: Dictionary)

func emit_experience_collected(amount: int) -> void:
	experience_collected.emit(amount)


func emit_money_collected(amount: int) -> void:
	money_collected.emit(amount)


func emit_money_spent(amount: int) -> void:
	money_spent.emit(amount)


func emit_health_damaged(current_health: float, max_health: float) -> void:
	health_damaged.emit(current_health, max_health)


func emit_health_healed(current_health: float, max_health: float) -> void:
	health_healed.emit(current_health, max_health)


func emit_buff_added(buff: Buff, current_buffs: Dictionary) -> void:
	buff_added.emit(buff, current_buffs)
