extends CanvasLayer

signal upgrade_selected(weapon_upgrade: WeaponUpgrade)

@export var weapon_upgrade_card_scene: PackedScene

@onready var close_button := %CloseButton as Button
@onready var weapon_upgrade_container := %WeaponUpgradeContainer as GridContainer


func _ready():
	get_tree().paused = true
	
	close_button.pressed.connect(on_close_button_pressed)


func on_close_button_pressed() -> void:
	get_tree().paused = false
	queue_free()


func on_upgrade_selected(weapon_upgrade) -> void:
	upgrade_selected.emit(weapon_upgrade)


func set_upgrades(upgrade_pool: Dictionary, current_upgrades: Dictionary) -> void:
	for weapon_upgrades_data in upgrade_pool.values():
		var weapon_upgrade_card_instance = weapon_upgrade_card_scene.instantiate()
		weapon_upgrade_container.add_child(weapon_upgrade_card_instance)
		weapon_upgrade_card_instance.set_upgrade(weapon_upgrades_data, current_upgrades)
		weapon_upgrade_card_instance.selected.connect(on_upgrade_selected)
