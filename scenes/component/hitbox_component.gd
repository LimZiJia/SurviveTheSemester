class_name HitboxComponent
extends Area2D

signal hit

@export var damage := 0.0
@export var knockback_force := 0.0

# Determines if the hitbox can freeze entities. For an entity to freeze,
# it must have the FreezableComponent.
@export var freezing := false

# Determines if the hitbox can burn entities. For an entity to burn,
# it must have the BurnableComponent.
@export var burning := false
