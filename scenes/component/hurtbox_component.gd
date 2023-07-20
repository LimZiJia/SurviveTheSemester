class_name HurtboxComponent
extends Area2D

# Emitted when the hitbox entered is attempting to burn the hurtbox.
# The effects only take place if the owner has a BurnableComponent.
signal burnt(dmg_per_tick: float)

# Emitted when the hitbox entered is attempting to freeze the hurtbox.
# The effects only take place if the owner has a FreezableComponent.
signal frozen

@export var health_component: HealthComponent
@export var velocity_component: VelocityComponent

@export var disabled := false:
	set(val):
		disabled = val
		for child in get_children():
			if child is CollisionShape2D:
				child.disabled = val
			if child is CollisionPolygon2D:
				child.disabled = val

func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(area: Area2D) -> void:
	if not area is HitboxComponent:
		return
	
	var hitbox_component := area as HitboxComponent
	
	hitbox_component.hit.emit()
	
	if health_component != null:
		health_component.damage(hitbox_component.damage)
		
		if hitbox_component.burning:
			burnt.emit(max(hitbox_component.damage * 0.2, 1.0))
		if hitbox_component.freezing:
			frozen.emit()
		AudioManager.play_2d_audio("damaged", self, -11.0, 0.9)
	
	if velocity_component != null:
		velocity_component.knockback(hitbox_component.global_position, hitbox_component.knockback_force)
