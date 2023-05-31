class_name HurtboxArea
extends Area2D

signal dead
signal health_changed(old_health: float, new_health: float)

@export var max_health: float
var health: float

func _init() -> void:
	monitorable = false


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	health = max_health


func _on_area_entered(area: Area2D) -> void:
	if area is HitboxArea:
		handle_hurt(area.damage)


func handle_hurt(damage: float) -> void:
	health -= damage
	health = clampf(health, 0, max_health)
	
	if health == 0:
		dead.emit()
	else:
		health_changed.emit(health + damage, health)
