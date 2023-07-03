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
		$HitboxComponent.freeze = true
	else:
		$AnimationPlayer.play("burn")
		$HitboxComponent.burn = true

func freeze() -> void:
	return

func burn() -> void:
	return
