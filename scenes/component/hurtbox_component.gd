class_name HurtboxComponent
extends Area2D

@export var health_component: HealthComponent
@export var velocity_component: VelocityComponent

func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(area: Area2D) -> void:
	if not area is HitboxComponent:
		return
	
	var hitbox_component := area as HitboxComponent
	
	if health_component != null:
		health_component.damage(hitbox_component.damage)
	
	if velocity_component != null:
		velocity_component.knockback(hitbox_component.knockback)