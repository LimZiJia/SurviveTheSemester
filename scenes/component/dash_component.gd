class_name DashComponent
extends Node2D

var can_dash = true
var ghost_scene = preload("res://resources/dash_ghost/dash_ghost.tscn")
@export var dash_duration = 0.2

func _ready():
	$Cooldown.timeout.connect(func(): can_dash = true)

func start_dash() -> void:
	can_dash = false
	$Cooldown.start()
	pass

func instance_ghost() -> void:
	var ghost: Sprite2D = ghost_scene.instantiate()
	get_parent().get_parent().add_child(ghost)
