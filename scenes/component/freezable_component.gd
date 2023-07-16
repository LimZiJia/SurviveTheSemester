class_name FreezableComponent
extends Node

@export var hurtbox_component: HurtboxComponent
@export var velocity_component: VelocityComponent

@export var sprite: CanvasItem
@export var tint_material: ShaderMaterial

var frozen_time := 2.0

var freezable_tween: Tween

func _ready() -> void:
	hurtbox_component.frozen.connect(on_frozen)


func on_frozen() -> void:
	GameEvents.emit_sound_made("freeze", -8.0, 1.0)
	if velocity_component:
		velocity_component.freeze(frozen_time)
	
	if freezable_tween != null and freezable_tween.is_valid():
		freezable_tween.kill()
	
	# Material might be overriden by another component manipulating material
	sprite.material = tint_material
	
	freezable_tween = create_tween()
	
	freezable_tween.tween_interval(frozen_time)
	freezable_tween.tween_callback(func(): sprite.material = null)
