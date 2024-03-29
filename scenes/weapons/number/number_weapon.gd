extends Node2D

@onready var hitbox_component := $HitboxComponent as HitboxComponent
@onready var sprite_2d := $Visuals/Sprite2D as Sprite2D


func _ready() -> void:
	pick_number()


func pick_number() -> void:
	var n = randi_range(0, 9)
	sprite_2d.frame = n
	if n <= 5:
		$AnimationPlayer.play("normal")
	elif n <= 7:
		$AnimationPlayer.play("freeze")
		$HitboxComponent.damage *= 0.5
		$HitboxComponent.knockback_force = 0.0
		$HitboxComponent.freezing = true
	else:
		$AnimationPlayer.play("burn")
		$HitboxComponent.burning = true

func meteor_falling_sound() -> void:
	AudioManager.play_audio("meteor_falling", -10.0, 1.5)

func meteor_impact_sound() -> void:
	AudioManager.play_audio("meteor_impact", -17.0)


func set_stats(damage: float, knockback: float, crit_multiplier: float, crit_chance: float) -> void:
	hitbox_component.damage = damage
	hitbox_component.knockback_force = knockback
	hitbox_component.crit_multiplier = crit_multiplier
	hitbox_component.crit_chance = crit_chance
