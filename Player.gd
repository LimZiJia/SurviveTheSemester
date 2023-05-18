class_name Player
extends Area2D

signal dead

@export var speed = 400.0
var screen_size = Vector2.ZERO
var health = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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

func start(new_position):
	position = new_position
	show()
	$CollisionShape2D.disabled = false

func damage_player(dmg):
	health -= dmg
	update_health()
	if health <= 0:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		emit_signal("dead")

func update_health():
	$HealthLabel.text = str(health)


func _on_body_entered(body):
	if body.is_in_group("mobs"):
		damage_player(body.dmg)
