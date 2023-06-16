extends Node2D


func _ready():
	GameEvents.weapon_added.connect(on_weapon_added)


func on_weapon_added(weapon: WeaponUpgradesData) -> void:
	var weapon_scene := weapon.weapon_scene as PackedScene
	var weapon_controller_instance := weapon_scene.instantiate() as Node
	add_child(weapon_controller_instance)
