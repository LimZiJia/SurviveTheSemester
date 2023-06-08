extends CharacterBody2D

@export var max_speed := 100.0
@export var acceleration := 15.0
@export var max_health := 10.0

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
	var target_velocity = direction * max_speed
	
	
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * acceleration))
	move_and_slide()


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
	
	velocity += attack.attack_dir * attack.knockback_force


func set_attack(attack: Attack) -> void:
	$HitboxArea.attack = attack
