extends Node2D

func set_damage(damage: float) -> void:
	%DamageLabel.text = str(int(damage))
	$AnimationPlayer.play("default")
