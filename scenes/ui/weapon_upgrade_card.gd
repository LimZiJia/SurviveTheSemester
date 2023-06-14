extends MarginContainer

signal selected

@onready var name_label = %NameLabel
@onready var cost_label = %CostLabel
@onready var quantity_label = %QuantityLabel
@onready var buy_button = %BuyButton


func _ready() -> void:
	buy_button.pressed.connect(on_buy_button_pressed)

func set_upgrade(upgrade: Upgrade, money_manager: Node)  -> void:
	print(upgrade.name)
	name_label.text = upgrade.name
	cost_label.text = "Cost: " + str(upgrade.cost)
	quantity_label.text = "?/" + str(upgrade.max_quantity)
	
	buy_button.disabled = upgrade.cost > money_manager.current_money


func on_buy_button_pressed() -> void:
	selected.emit()
