class_name WeaponStat
extends Resource

@export_range(0.05, 10, 0.05) var cooldown: float
@export_range(1, 10) var count: int
@export var damage: float
@export var knockback: float
@export var metadata: Dictionary = {}
