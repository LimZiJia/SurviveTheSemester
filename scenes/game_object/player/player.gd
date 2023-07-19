class_name Player
extends CharacterBody2D

signal dead

var is_damaged = false
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
@onready var stuck_area = $StuckArea as Area2D

func _ready() -> void:
	health_component.damaged.connect(on_health_component_damaged)
	health_component.healed.connect(on_health_component_healed)
	health_component.dead.connect(on_health_component_dead)
	stuck_area.area_entered.connect(unstuck)
	dash_duration = dash_component.dash_duration
	base_speed = velocity_component.max_speed
	GameEvents.buff_added.connect(on_buff_added)
	
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
			dash_component.start_dash(sprite)
			animation_player.play("dash_hurtbox")
		else:
			velocity_component.accelerate_in_direction(dir)
	else:
		animation_tree.set("parameters/conditions/idle", true)
		animation_tree.set("parameters/conditions/moving", false)
		animation_state.travel("Idle")
		velocity_component.decelerate()
	velocity_component.move(self)


func on_health_component_damaged(_damage: float) -> void:
	GameEvents.emit_health_damaged(health_component.current_health, health_component.max_health)
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

func unstuck(area: Area2D) -> void:
	print("stuck")
	if not area is WorldObject:
		return
	call_deferred("helper")
	var area_shape: RectangleShape2D = area.get_child(0).shape
	var x_to_param = area_shape.size.x / 2
	var y_to_param = area_shape.size.y / 2
	var delta_x = area.position.x - stuck_area.position.x
	var delta_y = area.position.y - stuck_area.position.y
	if delta_x < 0:
		delta_x = - (delta_x + x_to_param) - 19.0
	else:
		delta_x = x_to_param - delta_x + 19.0
	if delta_y < 0:
		delta_y = - (delta_y + y_to_param) - 19.0
	else:
		delta_y = y_to_param - delta_y + 19.0
	
	var dir: Vector2 = Vector2(delta_x, 0) if abs(delta_x) < abs(delta_y) else Vector2(0, delta_y)
	var duration: float = 0.1
	dir = dir.normalized()
	print(Vector2(-1, 0).normalized())
	print(dir)
	print(duration)
	self.set_collision_mask_value(16, false)
	velocity_component.dash(dir, duration)
	await get_tree().create_timer(duration, false).timeout
	self.set_collision_mask_value(16, true)
	
func helper() -> void:
	stuck_area.get_child(0).disabled = true
