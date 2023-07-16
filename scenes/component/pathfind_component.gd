@tool
class_name PathfindComponent
extends Node2D

@export var velocity_component: VelocityComponent

@onready var navigation_agent_2d := find_navigation_agent()


func set_target_position(target_position: Vector2) -> void:
	navigation_agent_2d.target_position = target_position


func follow_path() -> void:	
	if navigation_agent_2d.is_navigation_finished():
		velocity_component.decelerate()
		return
	
	var direction := to_local(navigation_agent_2d.get_next_path_position()).normalized()
	velocity_component.accelerate_in_direction(direction)
	navigation_agent_2d.set_velocity(velocity_component.velocity)


func find_navigation_agent() -> NavigationAgent2D:
	for child in get_children():
		if child is NavigationAgent2D:
			return child
	return null


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := [] as PackedStringArray
	
	if find_navigation_agent() == null:
		warnings.append(
			"A navigation agent must be provided for PathfindComponent " +
			"to function. Consider adding a NavigationAgent2D as a child.")
	
	return warnings
