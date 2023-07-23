extends CharacterBody2D

const ATTACK_RADIUS := 400.0

@export var pencil_scene: PackedScene
@export var exam_paper_spawner_scene: PackedScene

var base_health: float
var base_speed: float
var cur_speed: float
var base_damage: float
var base_stomp_damage: float
var exam_paper_difficulty: int

var is_angry := false
var played_angry_transition := false
var can_attack := true
var anim_is_moving := false:
	set(val):
		anim_is_moving = val
		animation_tree.set("parameters/conditions/idle", not val)
		animation_tree.set("parameters/conditions/moving", val)

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
@onready var angry_mark := $Visuals/TextureRect as TextureRect
@onready var cooldown_timer := $CooldownTimer as Timer

func _ready() -> void:
	base_health = health_component.max_health
	base_speed = velocity_component.max_speed
	base_damage = hitbox_component.damage
	
	state_machine.add_states(state_chasing)
	state_machine.add_states(state_angry_transitioning, enter_state_angry_transitioning)
	state_machine.add_states(state_choosing_attack, enter_state_choosing_attack)
	state_machine.add_states(state_throwing_pencil, enter_state_throwing_pencil, exit_state_attacking)
	state_machine.add_states(state_shooting_paper, enter_state_throwing_paper, exit_state_attacking)
	state_machine.add_states(state_freezing)
	state_machine.set_initial_state(state_chasing)
	state_machine.owner = self
	
	health_component.damaged.connect(on_health_component_damaged)
	cooldown_timer.timeout.connect(on_cooldown_timer_timeout)
	update_health_bar()
	
	freezable_component.frozen.connect(on_frozen)


func _physics_process(_delta: float) -> void:
	state_machine.update()


func state_chasing() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var target_position = player.global_position
	var target_distance = to_local(target_position).length()
	
	var dir = velocity_component.velocity.normalized()
	if dir != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", dir)
		animation_tree.set("parameters/Move/blend_position", dir)
		anim_is_moving = true
		animation_state.travel("Move")
		pathfind_component.set_target_position(target_position)
		pathfind_component.follow_path()
	else:
		anim_is_moving = false
		animation_state.travel("Idle")
		velocity_component.decelerate()
	
	velocity_component.move(self)
	
	if health_component.current_health / health_component.max_health < 0.25:
		if not played_angry_transition:
			state_machine.change_state(state_angry_transitioning)
	elif target_distance <= ATTACK_RADIUS and can_attack:
		state_machine.change_state(state_choosing_attack)


func state_angry_transitioning():
	decelerate_and_move()


func enter_state_angry_transitioning():
	played_angry_transition = true
	is_angry = true
	anim_is_moving = false
	
	animation_state.travel("Idle")
	AudioManager.play_2d_audio("angry", self, 10.0, 0.7)
	angry_mark.visible = true
	velocity_component.max_speed = velocity_component.max_speed * 2.4
	state_machine.change_state_with_delay(state_chasing, 1.5, true)


func state_choosing_attack():
	decelerate_and_move()


func enter_state_choosing_attack() -> void:
	anim_is_moving = false
	animation_state.travel("Idle")
	var rng = randi_range(0, 1)
	if rng == 0:
		state_machine.change_state_with_delay(state_throwing_pencil, 0.5, true)
	else:
		state_machine.change_state_with_delay(state_shooting_paper, 0.5, true)


func state_throwing_pencil():
	pass


func enter_state_throwing_pencil():
	can_attack = false
	
	var number = 2 if is_angry else 1
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	for i in number:
		animation_state.travel("Throw")
		
		var pencil = pencil_scene.instantiate()
		foreground.add_child(pencil)
		pencil.global_position = global_position
		pencil.global_position.y -= 100
		
		await get_tree().create_timer(1.0, false).timeout
		pencil.throw()
	
	state_machine.change_state_with_delay(state_chasing, 1.0, true)


func state_shooting_paper() -> void:
	pass


func enter_state_throwing_paper() -> void:
	can_attack = false
	
	var number = 5 if is_angry else 3
	var entities = get_tree().get_first_node_in_group("entities_layer") as Node2D
	if entities == null:
		return
	
	animation_state.travel("Throw")
	
	for i in number:
		var exam_paper_spawner_instance := exam_paper_spawner_scene.instantiate() as Node2D
		entities.add_child(exam_paper_spawner_instance)
		exam_paper_spawner_instance.global_position = global_position
		exam_paper_spawner_instance.start(exam_paper_difficulty)
	
	state_machine.change_state_with_delay(state_chasing, 1.0, true)


func exit_state_attacking():
	var wait_time = 5.0 if is_angry else 10.0
	cooldown_timer.start(wait_time)


func state_freezing() -> void:
	decelerate_and_move()


func enter_state_freezing() -> void:
	anim_is_moving = false


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


func decelerate_and_move():
	velocity_component.decelerate()
	velocity_component.move(self)


func set_difficulty(difficulty: int) -> void:
	if not is_inside_tree():
		await ready
	health_component.max_health = base_health * pow(difficulty, 0.1)
	health_component.current_health = base_health * pow(difficulty, 0.1)
	velocity_component.max_speed = base_speed * pow(difficulty, 0.07)
	hitbox_component.damage = base_damage * pow(difficulty, 0.15)
	exam_paper_difficulty = int(clampf(difficulty / 2, 1, INF))
	
	cur_speed = velocity_component.max_speed
	update_health_bar()
