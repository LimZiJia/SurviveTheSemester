extends Node

@export var health_component: HealthComponent
@export var sprite: CanvasItem
@export var hit_flash_material: ShaderMaterial

var hit_flash_tween: Tween

func _ready() -> void:
	health_component.damaged.connect(on_health_damaged)
	sprite.material = hit_flash_material

func on_health_damaged(_damage: float) -> void:
	if hit_flash_tween != null and hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, 0.2)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
