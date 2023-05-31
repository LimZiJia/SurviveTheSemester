extends Node

var score := 0
var is_playing := true

@onready var player := $Player as Player
@onready var hud := $HUD as CanvasLayer
@onready var pause_menu = $PauseMenu as CanvasLayer
@onready var wave_controller := $WaveController as Node2D
@onready var score_timer := $ScoreTimer as Timer

func _ready() -> void:
	player.dead.connect(_on_player_dead)
	hud.hide_buttons()
	
	hud.show_message_with_time("Get ready...", 1.0)
	await(get_tree().create_timer(1.0).timeout)
	
	wave_controller.start()
	score_timer.start()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") && is_playing:
		hud.hide_message()
		pause_menu.pause()


func _on_player_dead() -> void:
	is_playing = false
	wave_controller.stop()
	score_timer.stop()
	get_tree().call_group("mobs", "stop")
	
	hud.show_game_over()


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.score = score
