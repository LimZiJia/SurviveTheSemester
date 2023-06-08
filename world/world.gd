extends Node

@export var pause_menu_scene: PackedScene
@export var end_screen_scene: PackedScene

var score := 0

@onready var player := %Player as Player
@onready var hud := $HUD as CanvasLayer
@onready var wave_controller := $WaveController as Node2D
@onready var score_timer := $ScoreTimer as Timer

func _ready() -> void:
	player.dead.connect(_on_player_dead)
	player.damaged.connect(hud.update_health)
	
	await(get_tree().create_timer(1.0).timeout)
	
	wave_controller.start()
	score_timer.start()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pause_menu_instance = pause_menu_scene.instantiate()
		add_child(pause_menu_instance)


func _on_player_dead() -> void:
	wave_controller.stop()
	score_timer.stop()
	
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.score = score
	$WaveController.score = score
