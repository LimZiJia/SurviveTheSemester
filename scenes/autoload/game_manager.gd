extends Node

func _ready() -> void:
	Events.game_started.connect(_on_game_start)
	Events.game_restarted.connect(_on_game_restart)

func _on_game_start() -> void:
	SceneChanger.change_scene("res://scenes/world/world.tscn")

func _on_game_restart() -> void:
	if get_tree().current_scene.name == "World":
		SceneChanger.reload_scene()
	else:
		SceneChanger.change_scene("res://scenes/world/world.tscn")
