class_name ExperienceDropComponent
extends Node2D

@export var health_component: HealthComponent
@export var experience: int = 0

func _ready() -> void:
	if health_component == null:
		return
	
	health_component.dead.connect(on_health_component_dead)


func on_health_component_dead() -> void:
	GameEvents.emit_experience_collected(experience)
