extends CharacterBody2D

const ATTACK_RADIUS := 400.0
const ANGRY_ATTACK_RADIUS := 500.0

var base_health: float
var base_speed: float
var cur_speed: float
var base_damage: float
var base_stomp_damage: float
var is_angry = false
var played_transition = false
var can_attack = true

var state_machine := StateMachine.new()

@onready var health_component := $HealthComponent as HealthComponent
@onready var velocity_component := $VelocityComponent as VelocityComponent
@onready var pathfind_component := $PathfindComponent as PathfindComponent
@onready var hurtbox_component := $HurtboxComponent as HurtboxComponent
@onready var hitbox_component := $HitboxComponent as HitboxComponent
@onready var freezable_component := $FreezableComponent as FreezableComponent
@onready var health_bar := %HealthBar as ProgressBar
@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var animation_tree := $AnimationTree as AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var angry_mark = $Visuals/TextureRect as TextureRect
@onready var cooldown_timer = $Cooldown as Timer
@export var pencil_scene : PackedScene

func _ready() -> void:
	base_health = health_component.max_health
	base_speed = velocity_component.max_speed
	base_damage = hitbox_component.damage
	
	state_machine.add_states(state_chasing)
	state_machine.add_states(state_transitioning, enter_state_transitioning, exit_state_transitioning)
	state_machine.add_states(state_choosing_attack)
	state_machine.add_states(state_throwing_pencil, enter_state_attacking, exit_state_attacking)
	state_machine.add_states(state_shooting_paper, enter_state_attacking, exit_state_attacking)
	state_machine.add_states(state_freezing)
	state_machine.set_initial_state(state_chasing)
	state_machine.owner = self
	
	health_component.damaged.connect(on_health_component_damaged)
	cooldown_timer.timeout.connect(on_cooldown_timer_timeout)
	update_health_bar()
	
	freezable_component.frozen.connect(on_frozen)

func _physics_process(_delta: float) -> void:
	state_machine.update()
	if health_component.current_health / health_component.max_health < 0.5:
		is_angry = true
		velocity_component.max_speed = cur_speed * 1.5

func state_chasing() -> void:
	var dir = velocity_component.velocity.normalized()
	if velocity_component.is_dashing:
		pass
	elif dir != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", dir)
		animation_tree.set("parameters/Move/blend_position", dir)
		animation_tree.set("parameters/conditions/idle", false)
		animation_tree.set("parameters/conditions/moving", true)
		animation_state.travel("Move")

	else:
		animation_tree.set("parameters/conditions/idle", true)
		animation_tree.set("parameters/conditions/moving", false)
		animation_state.travel("Idle")
		velocity_component.decelerate()
	
	velocity_component.move(self)
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var target_position = player.global_position
	var target_distance = to_local(target_position).length()
	
	pathfind_component.set_target_position(target_position)
	pathfind_component.follow_path()
	velocity_component.move(self)
	
	if is_angry and not played_transition:
		state_machine.change_state(state_transitioning)
	elif target_distance <= ATTACK_RADIUS and can_attack:
		state_machine.change_state(state_choosing_attack)

func state_transitioning():
	stay_still()
	state_machine.change_state_with_delay(state_chasing, 1.5, true)

func enter_state_transitioning():
	AudioManager.play_2d_audio("angry", self, 10.0, 0.7)
	angry_mark.visible = true

func exit_state_transitioning():
	played_transition = true

func state_choosing_attack():
	stay_still()
	
	var rng = randi_range(0, 1)
	if rng == 0:
		state_machine.change_state_with_delay(state_throwing_pencil, 0.5, true)
	else:
		state_machine.change_state_with_delay(state_shooting_paper, 0.5, true)

func state_throwing_pencil():
	var pencil = pencil_scene.instantiate()
	pencil.global_position = self.global_position + Vector2(0, -10)
	await get_tree().create_timer(1.0).timeout
	pencil.throw()
	state_machine.change_state_with_delay(state_chasing, 2, true)

func state_shooting_paper():
	var pencil = pencil_scene.instantiate()
	pencil.global_position = self.global_position + Vector2(0, -10)
	await get_tree().create_timer(1.0).timeout
	pencil.throw()
	state_machine.change_state_with_delay(state_chasing, 2, true)

func enter_state_attacking():
	can_attack = false

func exit_state_attacking():
	cooldown_timer.wait_time = 5.0 if is_angry else 10.0
	cooldown_timer.start()

func state_freezing() -> void:
	stay_still()

func on_health_component_damaged(_damage: float) -> void:
	update_health_bar()

func on_cooldown_timer_timeout():
	can_attack = true

func update_health_bar() -> void:
	health_bar.value = health_component.current_health / health_component.max_health
	
func on_frozen(time: float) -> void:
	if state_machine.current_state in [state_chasing]:
		state_machine.change_state(state_freezing)
		state_machine.change_state_with_delay(state_chasing, time, false)

func stay_still():
	animation_tree.set("parameters/conditions/idle", true)
	animation_tree.set("parameters/conditions/moving", false)
	animation_state.travel("Idle")
	velocity_component.decelerate()
	velocity_component.move(self)

func set_difficulty(difficulty: int) -> void:
	if not is_inside_tree():
		await ready
	health_component.max_health = base_health * pow(difficulty, 0.1)
	health_component.current_health = base_health * pow(difficulty, 0.1)
	velocity_component.max_speed = base_speed * pow(difficulty, 0.07)
	hitbox_component.damage = base_damage * pow(difficulty, 0.15)
	
	cur_speed = velocity_component.max_speed
	update_health_bar()
