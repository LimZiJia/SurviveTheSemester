class_name HitboxComponent
extends Area2D

signal hit

@export var damage := 0.0
@export var knockback_force := 0.0

## If the damage was critical, the damage applied will be equivalent
## to damage * crit_multiplier.
@export_range(1.0, 10.0, 0.1) var crit_multiplier := 0.0

## The chance of any particular hit being critical.
@export_range(0.0, 1.0, 0.01) var crit_chance := 0.0

# Determines if the hitbox can freeze entities. For an entity to freeze,
# it must have the FreezableComponent.
@export var freezing := false

# Determines if the hitbox can burn entities. For an entity to burn,
# it must have the BurnableComponent.
@export var burning := false

@export var disabled := false:
	set(val):
		disabled = val
		for child in get_children():
			if child is CollisionShape2D:
				child.disabled = val
			if child is CollisionPolygon2D:
				child.disabled = val

var critical_damage: float:
	get = get_critical_damage

## Returns true crit_chance of the time, else false.
func is_crit() -> bool:
	var rnd = randf()
	return rnd <= crit_chance


func get_critical_damage() -> float:
	return damage * crit_multiplier
