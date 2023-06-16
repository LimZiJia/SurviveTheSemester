extends Node

# Dictionary of keys type StringName representing the weapon name,
# and values type WeaponUpgradesData representing the weapon upgrades.
@export var upgrade_pool: Dictionary
@export var shop_button: TextureButton
@export var shop_scene: PackedScene

var current_upgrades = {}

func _ready() -> void:
	if shop_button == null:
		return
	shop_button.pressed.connect(on_shop_button_pressed)
	
	initialize()


func on_shop_button_pressed() -> void:
	GameEvents.emit_money_collected(10000)
	var shop_instance = shop_scene.instantiate()
	get_parent().add_child(shop_instance)
	shop_instance.set_upgrades(upgrade_pool, current_upgrades)
	shop_instance.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(weapon_upgrade: WeaponUpgrade) -> void:
	apply_upgrade(weapon_upgrade)


# Adds the initial word weapon
func initialize() -> void:
	await get_parent().ready
	var word_init_upgrade = upgrade_pool["Word"].upgrades[0] as WeaponUpgrade
	apply_upgrade(word_init_upgrade)


func apply_upgrade(weapon_upgrade: WeaponUpgrade) -> void:
	var has_upgrade = current_upgrades.has(weapon_upgrade.weapon_name)
	if not has_upgrade:
		current_upgrades[weapon_upgrade.weapon_name] = {}
	current_upgrades[weapon_upgrade.weapon_name]["level"] = weapon_upgrade.level
	
	GameEvents.emit_money_spent(weapon_upgrade.cost)
	
	if weapon_upgrade.level == 1:
		var weapon_upgrades_data := upgrade_pool[weapon_upgrade.weapon_name] as WeaponUpgradesData
		GameEvents.emit_weapon_added(weapon_upgrades_data)
	
	GameEvents.emit_weapon_upgrade_added(weapon_upgrade)

