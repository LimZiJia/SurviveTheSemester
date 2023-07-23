class_name SaveGame
extends Resource

const SAVE_GAME_PATH := "user://save.tres"

@export var highscore: int = 0

func write_savegame() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)


static func save_exists() -> bool:
	return ResourceLoader.exists(SAVE_GAME_PATH)


static func load_savegame() -> Resource:
	return ResourceLoader.load(SAVE_GAME_PATH, "")
