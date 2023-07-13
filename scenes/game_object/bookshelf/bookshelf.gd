extends CharacterBody2D

const CHASE_RADIUS: float = 512.0

@export var book_scene: PackedScene

var base_health: float
var base_speed: float
var book_difficulty: int

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var health_component := $HealthComponent as HealthComponent
@onready var velocity_component := $VelocityComponent as VelocityComponent
@onready var pathfind_component := $PathfindComponent as PathfindComponent
@onready var health_bar := %HealthBar as ProgressBar



func _ready() -> void:
	base_health = health_component.max_health
	base_speed = velocity_component.max_speed

	$Timer.timeout.connect(on_timer_timeout)
	health_component.damaged.connect(on_health_component_damaged)
	update_health_bar()


func on_timer_timeout() -> void:
	animation_player.play("attack")
	

func _physics_process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		velocity_component.decelerate()
	else:
		var distance = player.global_position.distance_to(global_position)
		if distance > CHASE_RADIUS:
			pathfind_component.set_target_position(player.global_position)
			pathfind_component.follow_path()
		else:
			velocity_component.decelerate()
	
	velocity_component.move(self)


func on_health_component_damaged(_damage: float) -> void:
	update_health_bar()


func update_health_bar() -> void:
	health_bar.value = health_component.current_health / health_component.max_health


func spawn_book() -> void:
	var entities := get_tree().get_first_node_in_group("entities_layer") as Node2D
	if entities == null:
		return
	
	var spawn_position = global_position + Vector2.from_angle(randf_range(0, TAU)) * 128.0
	
	var book_instance := book_scene.instantiate() as Node2D
	book_instance.set_difficulty(book_difficulty)
	entities.add_child(book_instance)
	book_instance.global_position = spawn_position


# Set enemy stats based on difficulty provided
func set_difficulty(difficulty: int) -> void:
	if not is_inside_tree():
		await ready
	
	health_component.max_health = base_health * pow(difficulty, 0.1)
	health_component.current_health = base_health * pow(difficulty, 0.1)
	velocity_component.max_speed = base_speed * pow(difficulty, 0.07)
	book_difficulty = difficulty / 2
	
	update_health_bar()
