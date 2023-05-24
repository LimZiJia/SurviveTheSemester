class_name Projectile
extends Node2D

@export var max_speed := 1000.0
@export var lifetime := 3.0
@export var drag_factor := 0.05

var direction := Vector2.ZERO
var velocity := Vector2.ZERO
var target

@onready var hitbox := $HitboxArea
@onready var impact_detector := $ImpactDetector
@onready var visible_notifier := $VisibleOnScreenNotifier2D
@onready var despawn_timer := $DespawnTimer

func _ready() -> void:
	set_as_top_level(true)
	look_at(position + direction)
	
	despawn_timer.timeout.connect(queue_free)
	impact_detector.body_entered.connect(_on_impact)
	visible_notifier.screen_exited.connect(_on_screen_exit)
	visible_notifier.screen_exited.connect(_on_screen_enter)
	
	velocity = max_speed * direction


func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		target = null
		set_nearest_mob_as_target()
	if target:
		direction = global_position.direction_to(target.global_position)
	var desired_velocity := direction * max_speed
	var previous_velocity := velocity
	var change := (desired_velocity - previous_velocity) * drag_factor
	
	velocity += change
	velocity = velocity.limit_length(max_speed)
	
	position += velocity * delta
	look_at(global_position + velocity)


func set_nearest_mob_as_target() -> void:
	var mobs = get_tree().get_nodes_in_group("mobs")
	var cur_dist = INF if target == null else global_position.distance_to(target.global_position)
	for mob in mobs:
		var dist = global_position.distance_to(mob.global_position)
		if dist < cur_dist:
			target = mob
			cur_dist = dist


func _on_impact(body) -> void:
	if body.is_in_group("mobs"):
		queue_free()


func _on_screen_enter() -> void:
	despawn_timer.stop()


func _on_screen_exit() -> void:
	despawn_timer.start(lifetime)
