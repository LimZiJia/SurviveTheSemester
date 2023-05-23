class_name HurtboxArea
extends Area2D


@export var health_label: HealthLabel

func _init() -> void:
	monitorable = false

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func handle_hurt(damage: float) -> void:
	health_label.take_damage(damage)


func _on_area_entered(area: Area2D) -> void:
	if area is HitboxArea:
		handle_hurt(area.damage)
