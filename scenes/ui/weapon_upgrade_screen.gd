extends CanvasLayer

signal upgrade_selected(upgrade: Upgrade)

@export var weapon_upgrade_card_scene: PackedScene

@onready var close_button := %CloseButton as Button
@onready var weapon_card_container := %WeaponCardContainer as VBoxContainer

func _ready():
	get_tree().paused = true
	
	close_button.pressed.connect(on_close_button_pressed)
	GameEvents.upgrade_added.connect(on_upgrade_added)


func on_close_button_pressed() -> void:
	get_tree().paused = false
	queue_free()


func on_upgrade_selected(upgrade: Upgrade) -> void:
	upgrade_selected.emit(upgrade)


func on_upgrade_added(upgrade: Upgrade, current_upgrades: Dictionary) -> void:
	for child in weapon_card_container.get_children():
		pass


func set_upgrades(upgrades: Array[Upgrade], money_manager: Node) -> void:
	for upgrade in upgrades:
		var weapon_upgrade_card_instance = weapon_upgrade_card_scene.instantiate()
		weapon_card_container.add_child(weapon_upgrade_card_instance)
		weapon_upgrade_card_instance.set_upgrade(upgrade, money_manager)
		weapon_upgrade_card_instance.selected.connect(on_upgrade_selected.bind(upgrade))
