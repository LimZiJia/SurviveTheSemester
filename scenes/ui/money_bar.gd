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
	MoneyManager.money_updated.connect(on_money_updated)


func on_money_updated(new_amount: int) -> void:
	update_value(new_amount)


func update_value(new_amount: int) -> void:
	actual_value = new_amount
	
	if tween:
		tween.kill()
	tween = create_tween()
	
	tween.tween_property(self, "display_value", actual_value, TWEEN_TIME)
