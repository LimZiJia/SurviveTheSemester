extends RigidBody2D

@export var speed := 100.0

var target: Player = null

@onready var health_label := $HealthLabel as Label
@onready var hurtbox := $HurtboxArea as HurtboxArea
@onready var hitbox := $HitboxArea as HitboxArea

func _ready() -> void:
	if get_tree().has_group("player"):
		target = get_tree().get_first_node_in_group("player")
	hurtbox.dead.connect(queue_free)
	hurtbox.health_changed.connect(_on_health_changed)
	health_label.text = str(int(hurtbox.health))


func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	
	if target:
		direction = position.direction_to(target.position)
	
	position += direction * speed * delta


func _on_health_changed(_old_health: float, new_health: float) -> void:
	health_label.text = str(int(new_health))


func set_max_health(health: float) -> void:
	$HurtboxArea.max_health = health


func set_damage(damage: float) -> void:
	$HitboxArea.damage = damage


func stop() -> void:
	target = null
