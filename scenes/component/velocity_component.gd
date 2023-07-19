class_name VelocityComponent
extends Node

@export var max_speed := 100.0
@export var dash_speed = 1500.0
@export var acceleration := 20.0


var velocity := Vector2.ZERO
var is_frozen := false
var is_dashing := false

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
	if is_frozen:
		character_body.velocity = Vector2.ZERO
	else:
		character_body.velocity = velocity
	
	character_body.move_and_slide()
	velocity = character_body.velocity


func knockback(hitbox_position: Vector2, knockback_force: float) -> void:
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return
	
	var knockback_dir := hitbox_position.direction_to(owner.global_position)
	
	velocity += knockback_dir * knockback_force


func freeze(seconds: float) -> void:
	is_frozen = true
	await get_tree().create_timer(seconds, false).timeout
	is_frozen = false

func dash(direction: Vector2, duration: float) -> void:
	is_dashing = true
	var desired_velocity = direction * dash_speed
	velocity = desired_velocity
	await get_tree().create_timer(duration, false).timeout
	velocity = direction * max_speed
	is_dashing = false
