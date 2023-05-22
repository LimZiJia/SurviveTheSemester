extends RigidBody2D

@export var speed := 100.0
@onready var screen_size := get_viewport_rect().size
var target: Player = null


func _ready() -> void:
	if get_tree().has_group("player"):
		target = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	
	if target:
		direction = position.direction_to(target.position)
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += direction * speed * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func stop() -> void:
	target = null


func set_max_health(health: float) -> void:
	$HealthLabel.max_health = health


func set_damage(damage: float) -> void:
	$HitboxArea.damage = damage


func _on_health_label_dead():
	queue_free()
