class_name DashComponent
extends Node2D

@export var dash_duration := 0.2

## The time interval to spawn "ghost" sprites
@export var ghost_instance_interval := 0.03
@export var ghost_scene: PackedScene


## The sprite to display "ghost copies" of when dashing
@export var sprite: Sprite2D

var can_dash := true

## The offset needed for the ghost instance sprite's position. The default
## offset is the offset needed for the player sprite position.
var offset: Vector2 = Vector2(0, -50)

@onready var dash_cooldown_timer := $DashCooldownTimer as Timer

func _ready():
	dash_cooldown_timer.timeout.connect(on_dash_cooldown_timeout)


func on_dash_cooldown_timeout() -> void:
	can_dash = true


## Attempts to dash if it can dash. This function is called by the owner node,
## such as the player script for the player. Note that the owner node must
## check if the component is able to dash.
func dash() -> void:
	can_dash = false
	
	AudioManager.play_audio("dash", 0.0, 1.2)
	var loops = int(dash_duration / ghost_instance_interval)
	var tween = create_tween().set_loops(loops)
	tween.tween_callback(instance_ghost)
	tween.tween_interval(ghost_instance_interval)
	tween.finished.connect(dash_cooldown_timer.start)


func instance_ghost() -> void:
	if sprite == null:
		return
	
	var entities = get_tree().get_first_node_in_group("entities_layer") as Node2D
	if entities == null:
		return
	
	var ghost_instance := ghost_scene.instantiate() as Sprite2D
	entities.add_child(ghost_instance)
	
	ghost_instance.global_position = self.global_position + offset
	ghost_instance.clone(sprite)
