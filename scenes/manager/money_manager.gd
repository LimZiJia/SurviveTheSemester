extends Node

var current_money: int


func _ready() -> void:
	Events.game_started.connect(_on_game_start)
	Events.game_restarted.connect(_on_game_restart)
	GameEvents.money_collected.connect(on_money_collected)
	GameEvents.money_spent.connect(on_money_spent)
	GameEvents.experience_collected.connect(on_experience_collected)


func _on_game_start() -> void:
	current_money = 0


func _on_game_restart() -> void:
	current_money = 0


func on_money_collected(money: int) -> void:
	increment_money(money)


func on_money_spent(money: int) -> void:
	decrement_money(money)


func on_experience_collected(amount: float) -> void:
	GameEvents.emit_money_collected(int(amount))

func increment_money(money: int) -> void:
	current_money += money


func decrement_money(money: int) -> void:
	current_money = max(0, current_money - money)


func has_money(money: int) -> bool:
	return money <= current_money
