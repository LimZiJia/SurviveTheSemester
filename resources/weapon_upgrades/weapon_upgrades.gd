class_name WeaponUpgrades
extends Resource

# The name of the given weapon the upgrades are being defined for
@export var weapon_name: StringName

# The weapon_upgrades available.
@export var weapon_upgrades: Array[WeaponUpgrade]

# The weapon controller scene to instance when a weapon is newly addded.
@export var weapon_scene: PackedScene
