extends CharacterBody2D

@export var max_health := 10.0

var current_health: float

@onready var velocity_component := $VelocityComponent as VelocityComponent
@onready var health_label := $HealthLabel as Label
@onready var hurtbox := $HurtboxArea as HurtboxArea
@onready var hitbox := $HitboxArea as HitboxArea


func _ready() -> void:
	current_health = max_health
	hurtbox.damaged.connect(_on_damaged)
	health_label.text = str(int(current_health))


func _process(_delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)


func _on_damaged(attack: Attack) -> void:
	current_health -= attack.attack_damage
	current_health = clampf(current_health, 0, max_health)
	
	if current_health == 0.0:
		queue_free()
	else:
		health_label.text = str(int(current_health))
	
	velocity += attack.attack_dir * attack.knockback_force

func set_stats(health: float, speed: float, attack: Attack) -> void:
	max_health = health
	current_health = health
	$VelocityComponent.max_speed = speed
	$HitboxArea.attack = attack
