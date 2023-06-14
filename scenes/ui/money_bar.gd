extends Node2D

const TWEEN_TIME := 0.5

var tween: Tween
var actual_value: int = 0
var display_value: int = 0:
	set(value):
		display_value = value
		money_label.text = "%05d" % display_value


@onready var money_label := $MoneyLabel as Label


func _ready() -> void:
	GameEvents.money_collected.connect(on_money_updated)
	GameEvents.money_spent.connect(on_money_updated)


func on_money_updated(amount: int) -> void:
	update_value(MoneyManager.current_money)


func update_value(new_value: int) -> void:
	actual_value = new_value
	
	if tween:
		tween.kill()
	tween = create_tween()
	
	tween.tween_property(self, "display_value", actual_value, TWEEN_TIME)
