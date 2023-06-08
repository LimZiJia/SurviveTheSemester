extends Node2D

@export var max_speed := 600.0

const NAMES := [ "aiken", "dueet"]

var direction := Vector2.ZERO
var velocity := Vector2.ZERO

@onready var node = $Node2D
@onready var label = $Node2D/Label
@onready var hitbox = $HitboxComponent
@onready var impact_detector = $ImpactDetector
@onready var despawn_timer = $DespawnTimer

func _ready() -> void:
	choose_name()
	set_as_top_level(true)
	look_at(position + direction)
	
	var rot := fposmod(rotation_degrees, 360.0)
	
	if (90.0 < rot and rot < 270.0):
		node.rotation_degrees = 180.0
		label.set("offset_left", -label.get("offset_right")) 
		label.set("offset_right", 0.0)
	
	velocity = max_speed * direction
	
	impact_detector.body_entered.connect(_on_impact)
	despawn_timer.timeout.connect(_on_timeout)
	despawn_timer.start(1.0)


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
