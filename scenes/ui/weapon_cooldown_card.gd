extends MarginContainer

@onready var sprite := $Sprite2D as Sprite2D

func _ready() -> void:
	on_weapon_used(5.0)



func on_weapon_used(cooldown: float) -> void:
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 0.0)
	var tween = create_tween()
	tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 1.0, 
	cooldown)
	
	var rng = randf_range(0.3, 10.0)
	
	tween.finished.connect(on_weapon_used.bind(rng))
