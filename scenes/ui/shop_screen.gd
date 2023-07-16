extends CanvasLayer

signal upgrade_selected(weapon_upgrade: WeaponUpgrade)

@export var weapon_upgrade_card_scene: PackedScene

@onready var close_button := %CloseButton as Button
@onready var money_label := %MoneyLabel as Label
@onready var weapon_upgrade_container := %WeaponUpgradeContainer as GridContainer


func _ready():
	get_tree().paused = true
	
	set_money_label(MoneyManager.current_money)
	
	MoneyManager.money_updated.connect(on_money_updated)
	close_button.pressed.connect(on_close_button_pressed)


func on_close_button_pressed() -> void:
	get_tree().paused = false
	GameEvents.emit_sound_made("button_click", -5.0, 1.0)
	queue_free()


func on_upgrade_selected(weapon_upgrade) -> void:
	upgrade_selected.emit(weapon_upgrade)


func on_money_updated(new_money: int) -> void:
	set_money_label(new_money)


func set_upgrades(upgrade_pool: Dictionary, current_upgrades: Dictionary) -> void:
	for weapon_upgrades_data in upgrade_pool.values():
		var weapon_upgrade_card_instance = weapon_upgrade_card_scene.instantiate()
		weapon_upgrade_container.add_child(weapon_upgrade_card_instance)
		weapon_upgrade_card_instance.set_upgrade(weapon_upgrades_data, current_upgrades)
		weapon_upgrade_card_instance.selected.connect(on_upgrade_selected)


func set_money_label(new_money: int) -> void:
	money_label.text = "Coins: %d" % new_money
