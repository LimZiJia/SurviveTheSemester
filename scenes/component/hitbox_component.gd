class_name HitboxComponent
extends Area2D

signal hit

@export var damage := 0.0
@export var knockback_force := 0.0

@export var disabled := false:
	set(val):
		for child in get_children():
			if child is CollisionShape2D or CollisionPolygon2D:
				child.disabled = val
