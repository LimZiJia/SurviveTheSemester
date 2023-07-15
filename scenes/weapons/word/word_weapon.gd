extends Node2D

@export var max_speed := 600.0


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
	
	hitbox_component.hit.connect(on_hitbox_hit)
	
	impact_detector.body_entered.connect(_on_impact)
	despawn_timer.timeout.connect(_on_timeout)
	despawn_timer.start(1.0)


func _physics_process(delta: float) -> void:
	position += velocity * delta


# Removes the projectile when it collides with a mob
func on_hitbox_hit() -> void:
	queue_free()

# Removes the projectile when it collides with a mob or the world
func _on_impact(_body) -> void:
	queue_free()


func _on_timeout() -> void:
	queue_free()


func set_direction(given_direction: Vector2) -> void:
	direction = given_direction
	look_at(position + direction)
	
	var rot := fposmod(rotation_degrees, 360.0)
	
	if (90.0 < rot and rot < 270.0):
		visuals.rotation_degrees = 180.0
		label.set("offset_left", -label.get("offset_right")) 
		label.set("offset_right", 0.0)
	
	velocity = max_speed * direction

func choose_name() -> void:
	var idx := randi_range(0, 1)
	label.text = NAMES[idx]
	
	if idx == 0:
		GameEvents.emit_sound_made("i_can", -12.0, 1.25)
	else:
		GameEvents.emit_sound_made("do_it", -12.0, 1.25)
