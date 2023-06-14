extends MarginContainer

signal selected

@onready var name_label = %NameLabel
@onready var description_label = %DescriptionLabel
@onready var cost_label = %CostLabel
@onready var quantity_label = %QuantityLabel
@onready var buy_button = %BuyButton

var upgrade: Upgrade

func _ready() -> void:
	buy_button.pressed.connect(on_buy_button_pressed)
	GameEvents.upgrade_added.connect(on_upgrade_added)

func on_buy_button_pressed() -> void:
	selected.emit()


func on_upgrade_added(upgrade: Upgrade, current_upgrades: Dictionary) -> void:
	update_card(current_upgrades)


func set_upgrade(upgrade: Upgrade, current_upgrades: Dictionary)  -> void:
	self.upgrade = upgrade
	
	name_label.text = upgrade.name
	description_label.text = upgrade.description
	cost_label.text = "Cost: " + str(upgrade.cost)
	update_card(current_upgrades)


func update_card(current_upgrades: Dictionary) -> void:
	var quantity = 0
	if current_upgrades.has(upgrade.id):
		quantity = current_upgrades[upgrade.id]["quantity"]
	
	quantity_label.text = "%d/%d" % [quantity, upgrade.max_quantity]
	
	if quantity == upgrade.max_quantity or not MoneyManager.has_money(upgrade.cost):
		buy_button.disabled = true
	else:
		buy_button.disabled = false
