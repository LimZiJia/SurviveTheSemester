extends RigidBody2D

@export var speed := 100.0
@onready var health_label : HealthLabel = $HealthLabel
var target: Player = null


func _ready() -> void:
	if get_tree().has_group("player"):
		target = get_tree().get_first_node_in_group("player")
	health_label.dead.connect(queue_free)


func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	
	if target:
		direction = position.direction_to(target.position)
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += direction * speed * delta


func stop() -> void:
	target = null


func set_max_health(health: float) -> void:
	$HealthLabel.max_health = health


func set_damage(damage: float) -> void:
	$HitboxArea.damage = damage
