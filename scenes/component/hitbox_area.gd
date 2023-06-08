class_name HitboxArea
extends Area2D

@export var attack: Attack
@export var damage: float
@export var knockback_force: float

func _init() -> void:
	monitoring = false
