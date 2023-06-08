extends Node

@export var pause_menu_scene: PackedScene
@export var end_screen_scene: PackedScene

@onready var player := %Player as Player
@onready var hud := $HUD as CanvasLayer
@onready var wave_manager := $WaveManager as Node2D

func _ready() -> void:
	player.dead.connect(on_player_dead)
	player.damaged.connect(hud.update_health)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pause_menu_instance = pause_menu_scene.instantiate()
		add_child(pause_menu_instance)


func on_player_dead() -> void:
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
