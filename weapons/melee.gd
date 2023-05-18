class_name Melee
extends Node2D

@export var cooldown := 0.0
var can_attack := true


func attack() -> void:
	if can_attack:
		can_attack = false
		$CooldownTimer.start(cooldown)
		$AnimationPlayer.play("swing")

func _on_cooldown_timer_timeout() -> void:
	can_attack = true
