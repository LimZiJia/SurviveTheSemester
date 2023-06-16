class_name WeaponUpgradesData
extends Resource

# The name of the given weapon the upgrades are being defined for
@export var weapon_name: StringName

# The upgrades available.
@export var upgrades: Array[WeaponUpgrade]

# The weapon controller scene to instance when a weapon is newly addded.
@export var weapon_scene: PackedScene
