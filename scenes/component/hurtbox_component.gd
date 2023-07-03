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
	
	hitbox_component.hit.emit()
	
	if health_component != null:
		health_component.damage(hitbox_component.damage)
		if hitbox_component.burn:
			health_component.burn(max(hitbox_component.damage * 0.1, 1.0))
		if hitbox_component.freeze:
			health_component.freeze()
	
	if velocity_component != null:
		velocity_component.knockback(hitbox_component.global_position, hitbox_component.knockback_force)
