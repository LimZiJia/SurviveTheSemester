extends Node2D


func _ready():
	GameEvents.upgrade_added.connect(on_upgrade_added)


func on_upgrade_added(upgrade: Upgrade, current_upgrades: Dictionary) -> void:
	if current_upgrades[upgrade.id]["quantity"] == 1:
		var weapon_instance = upgrade.scene.instantiate()
		add_child(weapon_instance)
