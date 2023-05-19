extends Node


@export var mob_scene : PackedScene
var score := 0


func new_game() -> void:
	score = 0
	$HUD.update_score(score)
	
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartMarker.position)
	
	$StartTimer.start()
	$HUD.show_message("Get ready...")
	await($StartTimer.timeout)
	$ScoreTimer.start()
	$MobTimer.start()


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()



func _on_mob_timer_timeout() -> void:
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var mob = mob_scene.instantiate()
	add_child(mob)
	mob.position = mob_spawn_location.position


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
