extends Node


@export var mob_scene : PackedScene

func _ready():
	new_game()


func new_game():
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartMarker.position)
	$StartTimer.start()
	
	await($StartTimer.timeout)
	$MobTimer.start()


func game_over():
	$MobTimer.stop()



func _on_mob_timer_timeout():
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var mob = mob_scene.instantiate()
	add_child(mob)
	mob.position = mob_spawn_location.position
