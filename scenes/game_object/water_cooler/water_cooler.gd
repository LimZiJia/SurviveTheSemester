class_name WaterCooler
extends Area2D

signal collected

func _ready() -> void:
	body_entered.connect(on_body_entered)


func on_body_entered(body: Node2D) -> void:
	if body is Player:
		var health_component := (body as Player).health_component
		health_component.heal_percent(0.40)
		collected.emit()
		AudioManager.play_audio("drink", 12.0, 1.25)
		queue_free()
