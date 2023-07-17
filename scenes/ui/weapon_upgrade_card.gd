extends PanelContainer

signal selected(weapon_upgrade: WeaponUpgrade)

var weapon_upgrades_data: WeaponUpgradesData
var cur_level: int = 0

@onready var name_label := %NameLabel as Label
@onready var cost_label := %CostLabel as Label
@onready var quantity_label := %QuantityLabel as Label
@onready var description_label := %DescriptionLabel as Label
@onready var buy_button := %BuyButton as Button


func _ready():
	buy_button.pressed.connect(on_buy_button_pressed)
	GameEvents.weapon_upgrade_added.connect(on_weapon_upgrade_added)


func on_buy_button_pressed() -> void:
	# Attempt to prevent button spamming issues
	buy_button.disabled = true
	var next_upgrade := weapon_upgrades_data.upgrades[cur_level] as WeaponUpgrade
	cur_level += 1
	selected.emit(next_upgrade)
	GameEvents.emit_sound_made_shop("purchase", 0.0, 1.0)


func on_weapon_upgrade_added(_weapon_upgrade: WeaponUpgrade) -> void:
	update_card()


func set_upgrade(upgrades: WeaponUpgradesData, current_upgrades: Dictionary) -> void:
	weapon_upgrades_data = upgrades
	var has_upgrade = current_upgrades.has(weapon_upgrades_data.weapon_name)
	if has_upgrade:
		cur_level = current_upgrades[weapon_upgrades_data.weapon_name]["level"]
	
	name_label.text = weapon_upgrades_data.weapon_name
	update_card()


func update_card() -> void:
	# If an upgrade exists
	if cur_level < weapon_upgrades_data.upgrades.size():
		var next_upgrade := weapon_upgrades_data.upgrades[cur_level] as WeaponUpgrade
		description_label.text = next_upgrade.description
		cost_label.text = "Cost: $%d" % next_upgrade.cost
		buy_button.disabled = not MoneyManager.has_money(next_upgrade.cost)
	else:
		description_label.text = "You have maxed this weapon!"
		cost_label.text = "Cost: NIL"
		buy_button.disabled = true
	
	quantity_label.text = "%d/%d" % [cur_level, weapon_upgrades_data.upgrades.size()]
