class_name Player
extends CharacterBody2D

signal dead

const ACCELERATION := 20.0
const FRICTION := 40.0

@export var max_speed := 400.0
@onready var health := $HealthLabel
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")


enum { NORTH, EAST, SOUTH, WEST }
var facing := SOUTH
var is_damaged = false

func _ready() -> void:
	health.dead.connect(_on_dead)
	health.damaged.connect(_on_damaged)

func _physics_process(_delta: float) -> void:
	# Movement
	var dir = Vector2.ZERO
	dir.x = int(Input.is_action_pressed("move_right")) - \
		int(Input.is_action_pressed("move_left"))
	dir.y = int(Input.is_action_pressed("move_down")) - \
		int(Input.is_action_pressed("move_up"))
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


func _on_dead():
	queue_free()
	dead.emit()
	
func _on_damaged():
	is_damaged = true
	await(get_tree().create_timer(0.15).timeout)
	is_damaged = false
