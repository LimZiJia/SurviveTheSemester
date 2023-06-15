extends CharacterBody2D

@onready var health_component := $HealthComponent as HealthComponent
@onready var velocity_component := $VelocityComponent as VelocityComponent
@onready var hitbox_component := $HitboxComponent as HitboxComponent
@onready var health_bar := $HealthBar as ProgressBar


func _ready() -> void:
	health_component.damaged.connect(on_health_component_damaged)
	update_health_bar()


func _physics_process(_delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)


func on_health_component_damaged() -> void:
	update_health_bar()


func update_health_bar() -> void:
	health_bar.value = health_component.current_health / health_component.max_health


# Temporary function to set the stats of each enemy
func set_stats(health: float, speed: float, damage: float) -> void:
	$HealthComponent.max_health = health
	$HealthComponent.current_health = health
	$VelocityComponent.max_speed = speed
	$HitboxComponent.damage = damage
