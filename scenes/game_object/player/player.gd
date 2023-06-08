class_name Player
extends CharacterBody2D

signal dead
signal damaged(frac_cur_health: float)

enum { NORTH, EAST, SOUTH, WEST }
const ACCELERATION := 20.0
const FRICTION := 40.0

@export var max_health := 100.0
@export var max_speed := 400.0

var health := 0.0
var facing := SOUTH
var is_damaged = false

@onready var health_label := $HealthLabel as Label
@onready var hurtbox := $HurtboxArea as HurtboxArea
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var animation_tree = $AnimationTree as AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

func _ready() -> void:
	health = max_health
	hurtbox.damaged.connect(_on_damaged)
	health_label.text = str(int(hurtbox.health))
	
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


func _on_damaged(attack: Attack) -> void:
	health -= attack.attack_damage
	health = clampf(health, 0, max_health)
	health_label.text = str(int(health))
	damaged.emit(health / max_health)
	
	if health == 0:
		queue_free()
		dead.emit()
	else:
		is_damaged = true
		await(get_tree().create_timer(0.15).timeout)
		is_damaged = false

