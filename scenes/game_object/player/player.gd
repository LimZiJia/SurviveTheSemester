class_name Player
extends CharacterBody2D

signal dead
signal damaged(frac_cur_health: float)

enum { NORTH, EAST, SOUTH, WEST }
const ACCELERATION := 20.0
const FRICTION := 40.0

@export var max_health := 100.0
@export var max_speed := 400.0

var is_damaged = false

@onready var health_component := $HealthComponent as HealthComponent
@onready var health_label := $HealthLabel as Label
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var animation_tree = $AnimationTree as AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

func _ready() -> void:
	health_component.damaged.connect(on_health_component_damaged)
	health_component.dead.connect(on_health_component_dead)
	update_health_label()
	
func _physics_process(_delta: float) -> void:
	# Movement
	var dir = Vector2.ZERO
	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	dir = dir.normalized()
	
	if is_damaged:
		animation_state.travel("Hurt")
	elif dir != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", dir)
		animation_tree.set("parameters/Move/blend_position", dir)
		animation_tree.set("parameters/Hurt/blend_position", dir)
		animation_tree.set("parameters/conditions/idle", false)
		animation_tree.set("parameters/conditions/moving", true)
		animation_state.travel("Move")
		velocity = velocity.move_toward(dir * max_speed, ACCELERATION)
	else:
		animation_tree.set("parameters/conditions/idle", true)
		animation_tree.set("parameters/conditions/moving", false)
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	move_and_slide()


func update_health_label() -> void:
	health_label.text = str(int(health_component.current_health))


func on_health_component_damaged() -> void:
	update_health_label()
	damaged.emit(health_component.current_health / health_component.max_health)
	is_damaged = true
	await get_tree().create_timer(0.15).timeout
	is_damaged = false


func on_health_component_dead() -> void:
	dead.emit()
