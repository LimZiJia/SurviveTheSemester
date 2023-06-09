extends CharacterBody2D

@onready var health_component := $HealthComponent as HealthComponent
@onready var velocity_component := $VelocityComponent as VelocityComponent
@onready var hitbox_component := $HitboxComponent as HitboxComponent
@onready var health_label := $HealthLabel as Label


func _ready() -> void:
	health_component.damaged.connect(on_health_component_damaged)
	update_health_label()


func _process(_delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)


func on_health_component_damaged() -> void:
	update_health_label()


func update_health_label() -> void:
	health_label.text = str(int(health_component.current_health))


# Temporary function to set the stats of each enemy
func set_stats(health: float, speed: float, damage: float) -> void:
	$HealthComponent.max_health = health
	$HealthComponent.current_health = health
	$VelocityComponent.max_speed = speed
	$HitboxComponent.damage = damage
	$HealthLabel.text = str(int(health))
