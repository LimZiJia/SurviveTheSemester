class_name Player
extends CharacterBody2D

signal dead

const ACCELERATION := 20.0
const FRICTION := 40.0
@export var max_speed := 400.0
@onready var screen_size := get_viewport_rect().size
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

enum { NORTH, EAST, SOUTH, WEST }
var facing = EAST

func _ready() -> void:
	hide()
	

func _physics_process(delta) -> void:
	# Movement
	var dir = Vector2.ZERO
	dir.x = int(Input.is_action_pressed("move_right")) - \
		int(Input.is_action_pressed("move_left"))
	dir.y = int(Input.is_action_pressed("move_down")) - \
		int(Input.is_action_pressed("move_up"))
	dir = dir.normalized()
	if dir != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", dir)
		animation_tree.set("parameters/Move/blend_position", dir)
		animation_state.travel("Move")
		velocity = velocity.move_toward(dir * max_speed, ACCELERATION)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	move_and_slide()

	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# Attack
	if dir.x != 0:
		if dir.x > 0:
			facing = EAST
		else:
			facing = WEST
	elif dir.y != 0:
		if dir.y > 0:
			facing = SOUTH
		else:
			facing = NORTH
	
	if Input.is_action_just_pressed("attack"):
		$Melee.attack(facing)


func start(new_position: Vector2) -> void:
	position = new_position
	$HealthLabel.initialize_health()
	show()
	$HurtboxArea/CollisionShape2D.disabled = false


func _on_health_label_dead():
	hide()
	$HurtboxArea/CollisionShape2D.set_deferred("disabled", true)
	emit_signal("dead")
