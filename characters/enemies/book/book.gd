extends RigidBody2D

@export var speed := 100.0
@export var max_health := 10.0
@export var knockback_factor: float

var health: float
var target: Player = null
var knockback := Vector2.ZERO

@onready var health_label := $HealthLabel as Label
@onready var hurtbox := $HurtboxArea as HurtboxArea
@onready var hitbox := $HitboxArea as HitboxArea

func _ready() -> void:
	health = max_health
	if get_tree().has_group("player"):
		target = get_tree().get_first_node_in_group("player")
	hurtbox.damaged.connect(_on_damaged)
	health_label.text = str(int(health))


func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	knockback = knockback.move_toward(Vector2.ZERO, knockback_factor * delta)
	
	if target:
		direction = position.direction_to(target.position)
	
	position += direction * speed * delta + knockback


func _on_health_changed(_old_health: float, new_health: float) -> void:
	health_label.text = str(int(new_health))


func _on_damaged(attack: Attack) -> void:
	health -= attack.attack_damage
	health = clampf(health, 0, max_health)
	
	if health == 0:
		queue_free()
	else:
		health_label.text = str(int(health))
	
	# TODO: Add knockback
	knockback += attack.attack_dir * attack.knockback_force


func set_attack(attack: Attack) -> void:
	$HitboxArea.attack = attack


func stop() -> void:
	target = null
