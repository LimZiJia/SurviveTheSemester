extends Node

@export var upgrade_pool: Array[Upgrade]
@export var shop_button: TextureButton
@export var upgrade_scene: PackedScene

var current_upgrades = {}


func _ready():
	shop_button.pressed.connect(on_shop_button_pressed)
	
	get_parent().ready.connect(apply_upgrade.bind(load("res://resources/upgrades/word.tres")))

func on_shop_button_pressed() -> void:
	var upgrade_scene_instance = upgrade_scene.instantiate()
	get_parent().add_child(upgrade_scene_instance)
	upgrade_scene_instance.set_upgrades(upgrade_pool, current_upgrades)
	upgrade_scene_instance.upgrade_selected.connect(on_upgrade_selected)

func on_upgrade_selected(upgrade: Upgrade) -> void:
	apply_upgrade(upgrade)


func apply_upgrade(upgrade: Upgrade) ->  void:
	var has_upgrade = current_upgrades.has(upgrade.id)
	if not has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 0,
		}
	current_upgrades[upgrade.id]["quantity"] += 1
	
	GameEvents.emit_money_spent(upgrade.cost)
	GameEvents.emit_upgrade_added(upgrade, current_upgrades)
	
	
