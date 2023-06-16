extends Node

@export var upgrade_pool: Array[WeaponUpgrades]
@export var shop_button: TextureButton
@export var upgrade_scene: PackedScene
@export var initial_upgrades: Array[WeaponUpgrade]

var current_upgrades = {}

func _ready() -> void:
	shop_button.pressed.connect(on_shop_button_pressed)


func on_shop_button_pressed() -> void:
	var upgrade_scene_instance = upgrade_scene.instantiate()
	get_parent().add_child(upgrade_scene_instance)
	upgrade_scene_instance.set_upgrades(upgrade_pool, current_upgrades)
	upgrade_scene_instance.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(weapon_upgrades: WeaponUpgrades, level: int) -> void:
	apply_upgrade(weapon_upgrades, level)


func apply_upgrade(weapon_upgrades: WeaponUpgrades, level: int) -> void:
	var has_upgrade = current_upgrades.has(weapon_upgrades.weapon_name)
	if not has_upgrade:
		current_upgrades[weapon_upgrades.weapon_name] = {
			"weapon_upgrades": weapon_upgrades
		}
	current_upgrades[weapon_upgrades.weapon_name]["level"] = level
	
	# Emit money spent
	# Emit upgrade added
