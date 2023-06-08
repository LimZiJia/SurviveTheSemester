class_name HurtboxArea
extends Area2D

signal dead
signal damaged(attack: Attack)

@export var max_health: float
var health: float

func _init() -> void:
	monitorable = false


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	health = max_health


func _on_area_entered(area: Area2D) -> void:
	if area is HitboxArea:
		var hitbox := area as HitboxArea
		var attack := hitbox.attack
		attack.attack_dir = (global_position - hitbox.global_position).normalized()
		damaged.emit(attack)
