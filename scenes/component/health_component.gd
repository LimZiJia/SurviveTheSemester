class_name HealthComponent
extends Node2D

signal dead
signal damaged

@export var max_health := 10.0
var current_health: float


func _ready() -> void:
	current_health = max_health


func damage(amount: float) -> void:
	current_health = max(current_health - amount, 0.0)
	damaged.emit()
	check_death.call_deferred()


func check_death() -> void:
	if current_health == 0.0:
		dead.emit()
		owner.queue_free()
