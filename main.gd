extends Node


var score := 0


func new_game() -> void:
	score = 0
	$HUD.update_score(score)
	
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartMarker.position)
	
	$StartTimer.start()
	$HUD.show_message_with_time("Get ready...", 1.0)
	await($StartTimer.timeout)
	$ScoreTimer.start()
	$MobTimer.start()
	$WaveController.start()


func game_over() -> void:
	get_tree().call_group("mobs", "stop")
	$WaveController.stop()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
