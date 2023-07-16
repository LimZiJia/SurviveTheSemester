class_name HealthComponent
extends Node2D

signal dead
signal damaged(damage: float)
signal healed(health: float)
signal frozen
signal burnt(tick_damage: float)

@export var max_health := 10.0
var current_health: float


func _ready() -> void:
	current_health = max_health


func damage(amount: float) -> void:
	current_health = max(current_health - amount, 0.0)
	damaged.emit(amount)
	check_death.call_deferred()


func heal(amount: float) -> void:
	current_health = min(current_health + amount, max_health)
	healed.emit(amount)


func heal_percent(percent: float) -> void:
	heal(max_health * percent)


func increase_max_health(amount: float) -> void:
	max_health += amount
	heal(amount)


func increase_max_health_percent(percent: float) -> void:
	increase_max_health(max_health * percent)


func check_death() -> void:
	if current_health == 0.0:
		dead.emit()
		owner.queue_free()

func freeze() -> void:
	frozen.emit()
	
func burn(tick_damage: float) -> void:
	burnt.emit(tick_damage)
