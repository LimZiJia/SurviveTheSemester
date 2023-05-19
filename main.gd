extends Node


@export var mob_scene : PackedScene
var score := 0


func new_game() -> void:
	score = 0
	$HUD.update_score(score)
	
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartMarker.position)
	
	$StartTimer.start()
	$HUD.show_message_with_time("Get ready...", 2.0)
	await($StartTimer.timeout)
	$ScoreTimer.start()
	$MobTimer.start()


func game_over() -> void:
	get_tree().call_group("mobs", "stop")
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()



func _on_mob_timer_timeout() -> void:
	for i in range(10):
		var mob_spawn_location = $MobPath/MobSpawnLocation
		mob_spawn_location.progress_ratio = randf()
		var mob = mob_scene.instantiate()
		add_child(mob)
		mob.position = mob_spawn_location.position


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
