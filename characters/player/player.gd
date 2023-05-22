class_name Player
extends Area2D

signal dead

@export var speed := 400.0
@onready var screen_size := get_viewport_rect().size

enum {
	NORTH, NORTHEAST, EAST, SOUTHEAST,
	SOUTH, SOUTHWEST, WEST, NORTHWEST
}
var facing = 0 

func _ready() -> void:
	hide()


func _physics_process(delta) -> void:
	# Movement
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if direction.length() > 0:
		direction = direction.normalized()
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += direction * speed * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# Animation
	if direction.x != 0:
		$AnimatedSprite2D.animation = "right"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = direction.x < 0
	elif direction.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = direction.y > 0
	
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
	$AnimatedSprite2D.animation = "right"
	$HealthLabel.initialize_health()
	show()
	$HurtboxArea/CollisionShape2D.disabled = false


func _on_health_label_dead():
	hide()
	$HurtboxArea/CollisionShape2D.set_deferred("disabled", true)
	emit_signal("dead")
