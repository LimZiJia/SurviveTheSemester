extends Node

signal money_updated(new_amount: int)

var current_money: int = 0

func _ready() -> void:
	Events.game_started.connect(on_game_start)
	Events.game_restarted.connect(on_game_start)
	
	GameEvents.money_collected.connect(on_money_collected)
	GameEvents.money_spent.connect(on_money_spent)


func on_game_start() -> void:
	current_money = 0


func on_money_collected(amount: int) -> void:
	current_money += amount
	money_updated.emit(current_money)


func on_money_spent(amount: int) -> void:
	current_money = max(0, current_money - amount)
	money_updated.emit(current_money)


func has_money(amount: int) -> bool:
	return amount <= current_money
