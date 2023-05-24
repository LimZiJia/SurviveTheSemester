extends Node


var score := 0
var is_playing := false

func _ready() -> void:
	new_game()


func new_game() -> void:
	is_playing = true
	score = 0
	$HUD.update_score(score)
	
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartMarker.position)
	
	$HUD.show_message_with_time("Get ready...", 1.0)
	await(get_tree().create_timer(1.0).timeout)
	$ScoreTimer.start()
	$WaveController.start()


func game_over() -> void:
	is_playing = false
	get_tree().call_group("mobs", "stop")
	$WaveController.stop()
	$ScoreTimer.stop()
	$HUD.show_game_over()


func restart_game() -> void:
	$WaveController.stop()
	$ScoreTimer.stop()
	
	new_game()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") && is_playing:
		$HUD.hide_message()
		$PauseMenu.pause()


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)