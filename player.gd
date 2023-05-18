class_name Player
extends Area2D

signal dead

@export var speed := 400.0
@onready var screen_size := get_viewport_rect().size


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
	if Input.is_action_just_pressed("attack"):
		$Melee.attack()


func start(new_position: Vector2) -> void:
	position = new_position
	show()
	$CollisionShape2D.disabled = false


func _on_health_label_dead():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("dead")
