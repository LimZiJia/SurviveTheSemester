class_name HitboxArea
extends Area2D

@export var damage: float


func _on_area_entered(area: HurtboxArea):
	area.handle_hurt(damage)
