class_name VelocityComponent
extends Node

@export var max_speed := 100.0
@export var acceleration := 20.0

var velocity := Vector2.ZERO


func accelerate_to_player() -> void:
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var direction = owner_node2d.global_position.direction_to(player.global_position)
	accelerate_in_direction(direction)


func accelerate_in_direction(direction: Vector2) -> void:
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))


func decelerate() -> void:
	accelerate_in_direction(Vector2.ZERO)


func move(character_body: CharacterBody2D) -> void:
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity


func knockback(knockback_vector: Vector2) -> void:
	velocity += knockback_vector