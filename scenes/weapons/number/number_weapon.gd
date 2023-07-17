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
	GameEvents.emit_sound_made("meteor_falling", -10.0, 1.5)

func meteor_impact_sound() -> void:
	GameEvents.emit_sound_made("meteor_impact", -17.0, 1.0)
