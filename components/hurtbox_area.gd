class_name HurtboxArea
extends Area2D


@export var health_label: HealthLabel


# ensure type safety entity: hitbox
func handle_hurt(damage: float) -> void:
	health_label.take_damage(damage)


func _on_area_entered(area: HitboxArea) -> void:
	handle_hurt(area.damage)
