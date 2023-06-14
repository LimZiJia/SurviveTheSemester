extends Node

@export var upgrade_pool: Array[Upgrade]
@export var money_manager: Node
@export var shop_button: TextureButton
@export var upgrade_scene: PackedScene

var current_upgrades = {}


func _ready():
	shop_button.pressed.connect(on_shop_button_pressed)


func on_shop_button_pressed() -> void:
	var upgrade_scene_instance = upgrade_scene.instantiate()
	get_parent().add_child(upgrade_scene_instance)
	upgrade_scene_instance.set_upgrades(upgrade_pool, money_manager)
	upgrade_scene_instance.upgrade_selected.connect(on_upgrade_selected)

func on_upgrade_selected(upgrade: Upgrade) -> void:
	apply_upgrade(upgrade)


func apply_upgrade(upgrade: Upgrade) ->  void:
	var has_upgrade = current_upgrades.has(upgrade.id)
	if not has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1,
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	if upgrade.max_quantity != 0 and upgrade.max_quantity == current_upgrades[upgrade.id]["quantity"]:
		upgrade_pool = upgrade_pool.filter(func(pool_upgrade: Buff) -> bool:
			return pool_upgrade.id != upgrade.id
		)
	
	print(current_upgrades)
	
	GameEvents.emit_upgrade_added(upgrade, current_upgrades)
	
	
