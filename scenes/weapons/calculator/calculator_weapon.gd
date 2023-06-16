extends Node2D

# The maximum distance between the calculator and the player
const MAX_OUTER_RADIUS := 160.0

# The rate at which the calculator sprite internally rotates per second
const INTERNAL_ROTATION_RATE := 2.0

# The rate at which the calculator rotates about the player per second
const OUTER_ROTATION_RATE := 0.75
const START_TIME := 0.5
const END_TIME := 0.5

@export var attack_time := 10.0
@export var outer_rotation := 0.0

@onready var hitbox_component := $HitboxComponent as HitboxComponent
@onready var sprite_2d := $Sprite2D as Sprite2D

var outer_radius := 0.0
var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	
	if player == null:
		return
	
	start_calculator_tweens()

func _physics_process(_delta: float) -> void:
	update_position()

# Main driver of all tween logic
func start_calculator_tweens() -> void:
	start_background_tween(attack_time)
	start_radius_tween(MAX_OUTER_RADIUS, START_TIME)
	
	await get_tree().create_timer(attack_time - END_TIME, false).timeout
	
	start_radius_tween(0.0, END_TIME)
	await get_tree().create_timer(END_TIME, false).timeout
	queue_free()


# Controls internal and outer rotation of the weapon for the duration of the weapon.
# In other words, it makes the sprite rotate and increases the outer_rotation
# property that is used for the _physics movement method
func start_background_tween(seconds: float) -> void:
	var tween := create_tween().set_parallel()
	
	tween.tween_property(sprite_2d, "rotation",\
	sprite_2d.rotation + seconds *  INTERNAL_ROTATION_RATE * TAU, seconds)
	tween.tween_property(self, "outer_rotation",\
	outer_rotation + seconds * OUTER_ROTATION_RATE * TAU, seconds)


# Modifies the outer_radius field. 
# Used for the start and end section of the weapon.
func start_radius_tween(radius: float, seconds: float) -> void:
	var tween := create_tween()
	tween.tween_property(self, "outer_radius", radius, seconds)


# Moves the calculator weapon accordingly based on the interpolation being done
# by the tweens modifying the outer_rotation and outer_radius fields.
func update_position() -> void:
	var root_position := player.global_position
	global_position = root_position + Vector2.from_angle(outer_rotation) * outer_radius
