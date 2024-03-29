class_name Player
extends CharacterBody2D

signal dead

var is_damaged = false
var is_moving = false
var base_speed: float
var dash_speed: float
var dash_duration: float

@onready var dash_component = $DashComponent as DashComponent
@onready var velocity_component = $VelocityComponent as VelocityComponent
@onready var health_component := $HealthComponent as HealthComponent
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var animation_tree = $AnimationTree as AnimationTree
@onready var sprite = $Visuals/Sprite2D as Sprite2D
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var stuck_area := $StuckArea as Area2D

func _ready() -> void:
	health_component.damaged.connect(on_health_component_damaged)
	health_component.healed.connect(on_health_component_healed)
	health_component.dead.connect(on_health_component_dead)
	stuck_area.stuck.connect(on_stuck)
	dash_duration = dash_component.dash_duration
	base_speed = velocity_component.max_speed
	GameEvents.buff_added.connect(on_buff_added)
	
	add_to_group("player")


func _physics_process(_delta: float) -> void:
	# Movement
	var dir = Vector2.ZERO
	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	dir = dir.normalized()
	
	if is_damaged:
		animation_state.travel("Hurt")
	elif velocity_component.is_dashing:
		pass
	elif dir != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", dir)
		animation_tree.set("parameters/Move/blend_position", dir)
		animation_tree.set("parameters/Hurt/blend_position", dir)
		animation_tree.set("parameters/conditions/idle", false)
		animation_tree.set("parameters/conditions/moving", true)
		animation_state.travel("Move")

		if Input.is_action_just_pressed("dash") and dash_component.can_dash:
			velocity_component.dash(dir, dash_duration)
			dash_component.dash()
			animation_player.play("dash_hurtbox")
		else:
			velocity_component.accelerate_in_direction(dir)
			if !is_moving:
				$FootstepsPlayer.play()
				is_moving = true

	else:
		animation_tree.set("parameters/conditions/idle", true)
		animation_tree.set("parameters/conditions/moving", false)
		animation_state.travel("Idle")
		velocity_component.decelerate()
		if is_moving:
			$FootstepsPlayer.stop()
			is_moving = false
	velocity_component.move(self)


func on_health_component_damaged(_damage: float) -> void:
	GameEvents.emit_health_damaged(health_component.current_health, health_component.max_health)
	AudioManager.play_audio("player_hurt", -12.0)
	is_damaged = true
	await get_tree().create_timer(0.15).timeout
	is_damaged = false


func on_health_component_healed(_health: float) -> void:
	GameEvents.emit_health_healed(health_component.current_health, health_component.max_health)


func on_health_component_dead() -> void:
	dead.emit()
	

func on_buff_added(buff: Buff, current_buffs: Dictionary) -> void:
	if buff is BuffObtain:
		if buff.id == "regeneration":
			var buff_obtain_instance = buff.buff_obtain_scene.instantiate() as Node
			add_child(buff_obtain_instance)
			buff_obtain_instance.health_component = health_component
			
		return
	
	if buff.id == "speed":
		var percent_increase = current_buffs["speed"]["quantity"] * 0.1
		velocity_component.max_speed = base_speed * (1 + percent_increase)
	elif buff.id == "heal":
		health_component.heal_percent(0.2)
	elif buff.id == "max_health":
		health_component.increase_max_health_percent(0.2)


func on_stuck(safe_position: Vector2) -> void:
	unstuck(safe_position)


func unstuck(safe_position: Vector2) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", safe_position, 0.1)
	
