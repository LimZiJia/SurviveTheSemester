class_name HurtboxArea
extends Area2D


@export var health_label: HealthLabel


# ensure type safety entity: hitbox
func handle_hurt(damage: float) -> void:
	health_label.take_damage(damage)
