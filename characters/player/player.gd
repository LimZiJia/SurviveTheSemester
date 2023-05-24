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

enum {
	NORTH, NORTHEAST, EAST, SOUTHEAST,
	SOUTH, SOUTHWEST, WEST, NORTHWEST
}
var facing = EAST

func _ready() -> void:
	hide()
	

func _physics_process(delta) -> void:
	# Movement
	var direction = Vector2.ZERO
	direction.x = int(Input.is_action_pressed("move_right")) - \
		int(Input.is_action_pressed("move_left"))
	direction.y = int(Input.is_action_pressed("move_down")) - \
		int(Input.is_action_pressed("move_up"))
	direction = direction.normalized()
	if direction != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", direction)
		animation_tree.set("parameters/Move/blend_position", direction)
		animation_state.travel("Move")
		velocity = velocity.move_toward(direction * max_speed, ACCELERATION)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	move_and_slide()

	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# Attack
	if direction.x == 0 and direction.y == 0:
		pass
	else:
		if direction.x == 0 and direction.y < 0:
			facing = NORTH
		elif direction.x > 0 and direction.y < 0:
			facing = NORTHEAST
		elif direction.x > 0 and direction.y == 0:
			facing = EAST
		elif direction.x > 0 and direction.y > 0:
			facing = SOUTHEAST
		elif direction.x == 0 and direction.y > 0:
			facing = SOUTH
		elif direction.x < 0 and direction.y > 0:
			facing = SOUTHWEST
		elif direction.x < 0 and direction.y == 0:
			facing = WEST
		elif direction.x < 0 and direction.y < 0:
			facing = NORTHWEST
			
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
