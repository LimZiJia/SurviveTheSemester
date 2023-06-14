extends Node

var current_money: int


func _ready() -> void:
	GameEvents.money_collected.connect(on_money_collected)
	GameEvents.money_spent.connect(on_money_spent)


func on_money_collected(money: int) -> void:
	increment_money(money)


func on_money_spent(money: int) -> void:
	decrement_money(money)


func increment_money(money: int) -> void:
	current_money += money


func decrement_money(money: int) -> void:
	current_money -= money
