extends CharacterBody2D

var base_health: float
var base_speed: float
var base_damage: float


@onready var health_component := $HealthComponent as HealthComponent
@onready var velocity_component := $VelocityComponent as VelocityComponent
@onready var pathfind_component := $PathfindComponent as PathfindComponent
@onready var hitbox_component := $HitboxComponent as HitboxComponent
@onready var health_bar := %HealthBar as ProgressBar


func _ready() -> void:
	base_health = health_component.max_health
	base_speed = velocity_component.max_speed
	base_damage = hitbox_component.damage
	
	health_component.damaged.connect(on_health_component_damaged)
	update_health_bar()


func _physics_process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	var target: Vector2
	if player == null:
		target = global_position
	else:
		target = player.global_position
	
	pathfind_component.set_target_position(target)
	pathfind_component.follow_path()
	velocity_component.move(self)


func on_health_component_damaged(_damage: float) -> void:
	update_health_bar()


func update_health_bar() -> void:
	health_bar.value = health_component.current_health / health_component.max_health


# Set enemy stats based on difficulty provided
func set_difficulty(difficulty: int) -> void:
	if not is_inside_tree():
		await ready
	
	health_component.max_health = base_health * pow(difficulty, 0.1)
	health_component.current_health = base_health * pow(difficulty, 0.1)
	velocity_component.max_speed = base_speed * pow(difficulty, 0.07)
	hitbox_component.damage = base_damage * pow(difficulty, 0.15)
	
	update_health_bar()


# Temporary function to set the stats of each enemy
func set_stats(health: float, speed: float, damage: float) -> void:
	$HealthComponent.max_health = health
	$HealthComponent.current_health = health
	$VelocityComponent.max_speed = speed
	$HitboxComponent.damage = damage
