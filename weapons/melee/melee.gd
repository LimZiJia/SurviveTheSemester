extends Node2D

@export var cooldown := 0.0
var can_attack := true

# Swinging in a given direction. Starting from north = 0, it goes from 0-3
# for each of the posible 4 directions in increments of 90 degrees
func attack(direction: int) -> void:
	if can_attack:
		can_attack = false
		$CooldownTimer.start(cooldown)
		$AnimationPlayer.play("swing" + str(direction))

func _on_cooldown_timer_timeout() -> void:
	can_attack = true