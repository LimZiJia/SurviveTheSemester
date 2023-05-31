extends Node2D

@export var cooldown := 0.0

var can_attack := true

@onready var cooldown_timer := $CooldownTimer as Timer
@onready var animation_player := $AnimationPlayer as AnimationPlayer

# Upon cooldown timer running out, sets can_attack variable so that
# player can attack again
func _on_cooldown_timer_timeout() -> void:
	can_attack = true


# Swinging in a given direction. Starting from north = 0, it goes from 0-3
# for each of the posible 4 directions in increments of 90 degrees
func attack(direction: int) -> void:
	if can_attack:
		can_attack = false
		cooldown_timer.start(cooldown)
		animation_player.play("swing" + str(direction))
