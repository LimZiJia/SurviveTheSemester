extends CharacterBody2D

const CHASE_RADIUS: float = 512.0

@export var book_scene: PackedScene

var base_health: float
var base_speed: float
var book_difficulty: int = 1

var state_machine := StateMachine.new()

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var health_component := $HealthComponent as HealthComponent
@onready var velocity_component := $VelocityComponent as VelocityComponent
@onready var pathfind_component := $PathfindComponent as PathfindComponent
@onready var health_bar := %HealthBar as ProgressBar
@onready var timer := $Timer as Timer



func _ready() -> void:
	base_health = health_component.max_health
	base_speed = velocity_component.max_speed
	
	state_machine.add_states(state_chasing)
	state_machine.add_states(state_attacking, enter_state_attacking, leave_state_attacking)
	state_machine.set_initial_state(state_chasing)
	state_machine.owner = self

	timer.timeout.connect(on_timer_timeout)
	health_component.damaged.connect(on_health_component_damaged)
	update_health_bar()


func on_timer_timeout() -> void:
	animation_player.play("attack")
	

func _physics_process(_delta: float) -> void:
	state_machine.update()


func on_health_component_damaged(_damage: float) -> void:
	update_health_bar()


func update_health_bar() -> void:
	health_bar.value = health_component.current_health / health_component.max_health


func state_chasing() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var target_position = player.global_position
	var target_distance = target_position.distance_to(global_position)
	if target_distance <= CHASE_RADIUS:
		state_machine.change_state(state_attacking)
		return
	
	pathfind_component.set_target_position(target_position)
	pathfind_component.follow_path()
	velocity_component.move(self)


func state_attacking() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var target_position = player.global_position
	var target_distance = target_position.distance_to(global_position)
	if target_distance > CHASE_RADIUS:
		state_machine.change_state(state_chasing)
		return
	
	velocity_component.decelerate()
	velocity_component.move(self)


func enter_state_attacking() -> void:
	timer.start()


func leave_state_attacking() -> void:
	timer.stop()


func spawn_book() -> void:
	var entities := get_tree().get_first_node_in_group("entities_layer") as Node2D
	if entities == null:
		return
	
	var book_instance := book_scene.instantiate() as Node2D
	book_instance.set_difficulty(book_difficulty)
	entities.add_child(book_instance)
	# Slight offset to place the book behind the bookshelf
	book_instance.global_position = global_position + Vector2(0, -13)
	book_instance.play_spawn()


# Set enemy stats based on difficulty provided
func set_difficulty(difficulty: int) -> void:
	if not is_inside_tree():
		await ready
	
	health_component.max_health = base_health * pow(difficulty, 0.1)
	health_component.current_health = base_health * pow(difficulty, 0.1)
	velocity_component.max_speed = base_speed * pow(difficulty, 0.07)
	book_difficulty = int(clampf(difficulty / 2.0, 1.0, INF))
	
	update_health_bar()
