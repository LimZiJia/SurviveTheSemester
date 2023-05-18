class_name HealthLabel
extends Label

signal dead

@export var max_health: float
var health: float

func take_damage(dmg: float) -> void:
	health -= dmg
	health = clampf(health, 0, max_health)
	update_label()
	if health == 0:
		emit_signal("dead")


func update_label() -> void:
	text = str(int(round(health)))


func initialize_health() -> void:
	health = max_health
	update_label()

func _ready() -> void:
	initialize_health()
