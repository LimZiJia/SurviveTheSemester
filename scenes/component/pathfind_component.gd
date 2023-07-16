class_name PathfindComponent
extends Node2D

@export var velocity_component: VelocityComponent

@onready var navigation_agent_2d := $NavigationAgent2D as NavigationAgent2D

func set_target_position(target_position: Vector2) -> void:
	navigation_agent_2d.target_position = target_position


func follow_path() -> void:
	if navigation_agent_2d.is_navigation_finished():
		velocity_component.decelerate()
		return
	
	var direction := to_local(navigation_agent_2d.get_next_path_position()).normalized()
	velocity_component.accelerate_in_direction(direction)
	navigation_agent_2d.set_velocity(velocity_component.velocity)
