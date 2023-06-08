extends RigidBody2D

@export var speed := 100.0
@export var max_health := 10.0
@export var knockback_factor: float

var health: float
var knockback := Vector2.ZERO

@onready var health_label := $HealthLabel as Label
@onready var hurtbox := $HurtboxArea as HurtboxArea
@onready var hitbox := $HitboxArea as HitboxArea

func _ready() -> void:
	health = max_health
	hurtbox.damaged.connect(_on_damaged)
	health_label.text = str(int(health))


func _physics_process(delta: float) -> void:
	var direction = get_direction_to_player()
	knockback = knockback.move_toward(Vector2.ZERO, knockback_factor * delta)
	
	position += direction * speed * delta + knockback


func get_direction_to_player() -> Vector2:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	return global_position.direction_to(player.global_position)

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
