extends Node2D

@export var max_speed := 600.0
@export var knockback_factor := 1500.0

const NAMES := [ "aiken", "dueet"]

var direction := Vector2.ZERO:
	set = set_direction
var velocity := Vector2.ZERO

@onready var visuals = $Visuals
@onready var label = $Visuals/Label
@onready var hitbox_component = $HitboxComponent
@onready var impact_detector = $ImpactDetector
@onready var despawn_timer = $DespawnTimer

func _ready() -> void:
	choose_name()
	set_as_top_level(true)
	
	impact_detector.body_entered.connect(_on_impact)
	despawn_timer.timeout.connect(_on_timeout)
	despawn_timer.start(1.0)


func set_damage(damage: float) -> void:
	($HitboxComponent as HitboxComponent).damage = damage

func set_direction(given_direction: Vector2) -> void:
	direction = given_direction
	look_at(position + direction)
	hitbox_component.knockback = knockback_factor * Vector2.from_angle(global_rotation)
	
	var rot := fposmod(rotation_degrees, 360.0)
	
	if (90.0 < rot and rot < 270.0):
		visuals.rotation_degrees = 180.0
		label.set("offset_left", -label.get("offset_right")) 
		label.set("offset_right", 0.0)
	
	velocity = max_speed * direction

func choose_name() -> void:
	var idx := randi_range(0, 1)
	label.text = NAMES[idx]


func _physics_process(delta: float) -> void:
	position += velocity * delta


# Removes the projectile when it collides with a mob or the world
func _on_impact(_body) -> void:
	queue_free()


func _on_timeout() -> void:
	queue_free()
