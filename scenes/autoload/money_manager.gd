extends Node

signal money_changed(cur_money: int)

var current_money: int

func _ready() -> void:
	Events.game_started.connect(on_game_start)
	Events.game_restarted.connect(on_game_start)


func on_game_start() -> void:
	current_money = 0


func on_money_collected(amount: int) -> void:
	current_money += amount
	money_changed.emit(current_money)


func on_money_spent(amount: int) -> void:
	current_money -= amount
	money_changed.emit(current_money)


func has_money(amount: int) -> bool:
	return amount <= current_money
