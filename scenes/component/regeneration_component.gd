extends Node

@export var health_component: HealthComponent
@export var health_per_second := 0.5

var cooldown := 5.0

@onready var timer := $Timer as Timer


func _ready() -> void:
	timer.wait_time = cooldown
	timer.timeout.connect(on_timer_timeout)
	
	timer.start()


func on_timer_timeout() -> void:
	if health_component:
		health_component.heal(health_per_second * cooldown)
