extends CharacterBody2D

## The radius within which the exam paper will start preparing its
## attack sequence.
const ATTACK_RADIUS := 200.0

var base_health: float
var base_speed: float
var base_damage: float
var dash_speed := 700.0

var state_machine := StateMachine.new()

## Helper variable representing the global position of the target
## for drawing purposes
var target_local_position: Vector2
## Helper variable representing if the node should draw
var can_draw := false


@onready var health_component := $HealthComponent as HealthComponent
@onready var velocity_component := $VelocityComponent as VelocityComponent
@onready var dash_velocity_component := $DashVelocityComponent as VelocityComponent
@onready var pathfind_component := $PathfindComponent as PathfindComponent
@onready var hitbox_component := $HitboxComponent as HitboxComponent
@onready var health_bar := %HealthBar as ProgressBar


func _ready() -> void:
	base_health = health_component.max_health
	base_speed = velocity_component.max_speed
	base_damage = hitbox_component.damage
	
	state_machine.add_states(state_chasing)
	state_machine.add_states(state_locking, enter_state_locking, leave_state_locking)
	state_machine.add_states(state_predashing, enter_state_predashing)
	state_machine.add_states(state_dashing, enter_state_dashing, leave_state_dashing)
	state_machine.set_initial_state(state_chasing)
	
	health_component.damaged.connect(on_health_component_damaged)
	update_health_bar()


func _physics_process(_delta: float) -> void:
	state_machine.update()


func _draw() -> void:
	if can_draw:
		draw_dashed_line(Vector2.ZERO, target_local_position, Color.RED, 2.0, 4.0)


func state_chasing() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var target_position = player.global_position
	var target_distance = to_local(target_position).length()
	
	if target_distance <= ATTACK_RADIUS:
		state_machine.change_state(state_locking)
		return
	
	pathfind_component.set_target_position(target_position)
	pathfind_component.follow_path()
	velocity_component.move(self)

## This state occurs when the player is close enough and is in line of sight.
## During this state, the enemy locks in on the player's location. After this
## state, even if the player moves, the target location has already been locked.
func state_locking() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var target_position = player.global_position
	var target_distance = to_local(target_position).length()
	
	velocity_component.decelerate()
	velocity_component.move(self)
	
	var space_state = get_world_2d().direct_space_state
	# Ray only intersects with world or world objects
	var query = PhysicsRayQueryParameters2D.create(global_position, target_position,
	0b10001, [self])
	var result = space_state.intersect_ray(query)
	
	if result:
		state_machine.change_state(state_chasing)
		return
	
	target_local_position = to_local(target_position)
	queue_redraw()


func enter_state_locking() -> void:
	can_draw = true
	
	var tween = create_tween()
	tween.tween_interval(1.5)
	tween.tween_callback(state_machine.change_state.bind(state_predashing))
	state_machine.state_changed.connect(tween.kill)


func leave_state_locking() -> void:
	# Removes the drawing of the line
	can_draw = false
	queue_redraw()


func state_predashing() -> void:
	velocity_component.decelerate()
	velocity_component.move(self)


func enter_state_predashing() -> void:
	var tween = create_tween()
	tween.tween_interval(0.5)
	tween.tween_callback(state_machine.change_state.bind(state_dashing))
	state_machine.state_changed.connect(tween.kill)


func state_dashing() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	dash_velocity_component.accelerate_in_direction(target_local_position.normalized())
	dash_velocity_component.move(self)
	

func enter_state_dashing() -> void:
	# While dashing, it does not collide with other mobs
	collision_layer = 0b0
	collision_mask = 0b10001
	wall_min_slide_angle = INF
	
	var tween = create_tween()
	tween.tween_interval(0.5)
	tween.tween_callback(state_machine.change_state.bind(state_chasing))
	state_machine.state_changed.connect(tween.kill)


func leave_state_dashing() -> void:
	collision_layer = 0b1000
	collision_mask = 0b11001
	wall_min_slide_angle = 0.0


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
