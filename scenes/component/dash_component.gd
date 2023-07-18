class_name DashComponent
extends Node2D

@export var dash_duration = 0.2
var can_dash = true
var ghost_scene = preload("res://resources/dash_ghost/dash_ghost.tscn")
var sprite: Sprite2D
var offset: Vector2 = Vector2(0, -50)

@onready var duration = $Duration
@onready var cooldown = $Cooldown
@onready var ghost_interval = $Ghost

func _ready():
	duration.timeout.connect(func(): cooldown.start(); ghost_interval.stop())
	cooldown.timeout.connect(func(): can_dash = true)
	ghost_interval.timeout.connect(instance_ghost)

func start_dash(sprite: Sprite2D) -> void:
	can_dash = false
	duration.start()
	self.sprite = sprite
	ghost_interval.start()

func instance_ghost() -> void:
	var ghost: Sprite2D = ghost_scene.instantiate()
	get_parent().get_parent().add_child(ghost)
	
	ghost.global_position = self.global_position + offset
	ghost.texture = sprite.texture
	ghost.vframes = sprite.vframes
	ghost.hframes = sprite.hframes
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h
	ghost.flip_v = sprite.flip_v
