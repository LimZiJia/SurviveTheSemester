extends Node

@export var end_screen_scene: PackedScene


func _ready() -> void:
	%Player.dead.connect(on_player_dead)


func on_player_dead() -> void:
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
