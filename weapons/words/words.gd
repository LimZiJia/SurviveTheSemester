extends Node2D

@export var max_speed := 1000.0

const NAMES := [ "aiken", "dueet"]

var direction := Vector2.ZERO
var velocity := Vector2.ZERO

@onready var label = $Label
@onready var hitbox = $HitboxArea
@onready var impact_detector = $ImpactDetector

func _ready() -> void:
	choose_name()
	set_as_top_level(true)
	look_at(position + direction)
	
	# Temporary fix to make the words readable, but now the 
	# position of the flipped words is wrong
	if (rotation_degrees > 90.0 or rotation_degrees < -90.0):
		rotation_degrees += 180
	
	impact_detector.body_entered.connect(_on_impact)
	
	velocity = max_speed * direction


func choose_name() -> void:
	var idx := randi_range(0, 1)
	label.text = NAMES[idx]


func _physics_process(delta: float) -> void:
	position += velocity * delta


# Removes the projectile when it collides with a mob or the world
func _on_impact(body) -> void:
	print(body)
	queue_free()
