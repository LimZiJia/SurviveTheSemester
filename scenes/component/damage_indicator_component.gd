class_name DamageIndicatorComponent
extends Node2D

@export var damage_indicator_scene: PackedScene
@export var health_component: HealthComponent

func _ready() -> void:
	health_component.damaged.connect(on_health_component_damaged)


func on_health_component_damaged(damage: float) -> void:
	var damage_indicator_instance = damage_indicator_scene.instantiate() as Node2D
	
	
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	foreground.add_child(damage_indicator_instance)
	damage_indicator_instance.global_position = global_position
	damage_indicator_instance.set_damage(damage)
