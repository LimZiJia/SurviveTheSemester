extends Node


func reload_scene_with_delay(delay: float = 0) -> void:
	await(get_tree().create_timer(delay).timeout)
	get_tree().reload_current_scene()


func reload_scene() -> void:
	reload_scene_with_delay(0.0)


func change_scene(scene: String, delay: float = 0) -> void:
	await(get_tree().create_timer(delay).timeout)
	if get_tree().change_scene_to_file(scene) != OK:
		printerr("Failed to change to scene %s" % scene)
