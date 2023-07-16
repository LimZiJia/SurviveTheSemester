extends CharacterBody2D

const ATTACK_RADIUS := 392.0

var base_health: float
var base_speed: float
var base_damage: float

var state_machine := StateMachine.new()

@onready var attack_fill_timer := $AttackFillTimer as Timer
@onready var health_component := $HealthComponent as HealthComponent
@onready var velocity_component := $VelocityComponent as VelocityComponent
@onready var pathfind_component := $PathfindComponent as PathfindComponent
@onready var hurtbox_component := $HurtboxComponent as HurtboxComponent
@onready var hitbox_component := $HitboxComponent as HitboxComponent
@onready var jump_hitbox_component := $JumpHitboxComponent as HitboxComponent
@onready var health_bar := %HealthBar as ProgressBar


func _ready() -> void:
	base_health = health_component.max_health
	base_speed = velocity_component.max_speed
	base_damage = hitbox_component.damage
	
	state_machine.add_states(state_chasing, enter_state_chasing)
	state_machine.add_states(state_jump_charging, enter_state_jump_charging)
	state_machine.add_states(state_jumping, enter_state_jumping, leave_state_jumping)
	state_machine.add_states(state_damage_dealing, enter_state_damage_dealing, leave_state_damage_dealing)
	state_machine.set_initial_state(state_chasing)
	
	health_component.damaged.connect(on_health_component_damaged)
	update_health_bar()


func _physics_process(_delta: float) -> void:
	state_machine.update()


func state_chasing() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var target_position = player.global_position
	var target_distance = to_local(target_position).length()
	
	pathfind_component.set_target_position(target_position)
	pathfind_component.follow_path()
	velocity_component.move(self)
	
	if target_distance <= ATTACK_RADIUS and not is_player_obstructed():
		state_machine.change_state(state_jump_charging)


func enter_state_chasing() -> void:
	attack_fill_timer.paused = true


func state_jump_charging() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var target_position = player.global_position
	var target_distance = to_local(target_position).length()
	
	velocity_component.decelerate()
	velocity_component.move(self)
	
	if target_distance >= ATTACK_RADIUS or is_player_obstructed():
		state_machine.change_state(state_chasing)
	elif attack_fill_timer.time_left == 0:
		state_machine.change_state(state_jumping)


func enter_state_jump_charging() -> void:
	attack_fill_timer.paused = false


func state_jumping() -> void:
	pass


func enter_state_jumping() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	var target_position = player.global_position
	
	# Stop collisions and damage dealing/taking
	hitbox_component.disabled = true
	hurtbox_component.disabled = true
	collision_layer = 0b0
	collision_mask = 0b1
	remove_from_group("mobs")
	
	# Jumping Animation
	var height_tween = create_tween()
	var position_tween = create_tween()
	
	height_tween.tween_property(%JumpingVisuals, "position:y", -240.0, 0.6
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	height_tween.tween_property(%JumpingVisuals, "position:y", 0.0, 0.5
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	
	position_tween.tween_property(self, "position", target_position,
	1.2).set_trans(Tween.TRANS_LINEAR)
	position_tween.tween_callback(state_machine.change_state.bind(state_damage_dealing))


func leave_state_jumping() -> void:
	# Resume collisions
	collision_layer = 0b1000
	collision_mask = 0b11001
	add_to_group("mobs")


func state_damage_dealing() -> void:
	velocity_component.decelerate()
	velocity_component.move(self)


func enter_state_damage_dealing() -> void:
	hurtbox_component.disabled = false
	jump_hitbox_component.disabled = false
	
	var tween = create_tween()
	tween.tween_interval(0.1)
	tween.tween_callback(state_machine.change_state.bind(state_chasing))


func leave_state_damage_dealing() -> void:
	jump_hitbox_component.disabled = true
	hitbox_component.disabled = false
	attack_fill_timer.start()


func on_health_component_damaged(_damage: float) -> void:
	update_health_bar()


func update_health_bar() -> void:
	health_bar.value = health_component.current_health / health_component.max_health


## Returns true if there are walls between player and enemy,
## else returns false
func is_player_obstructed() -> bool:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return true
	
	var space_state = get_world_2d().direct_space_state
	# Ray only intersects with world or world objects
	var query = PhysicsRayQueryParameters2D.create(global_position, 
	player.global_position, 0b1, [self])
	var result = space_state.intersect_ray(query)
		
	return not result.is_empty()


# Set enemy stats based on difficulty provided
func set_difficulty(difficulty: int) -> void:
	if not is_inside_tree():
		await ready
	
	health_component.max_health = base_health * pow(difficulty, 0.1)
	health_component.current_health = base_health * pow(difficulty, 0.1)
	velocity_component.max_speed = base_speed * pow(difficulty, 0.07)
	hitbox_component.damage = base_damage * pow(difficulty, 0.15)
	
	update_health_bar()
