extends Node2D

var master_volume: float:
	get = get_master_volume, set = set_master_volume

var music_volume: float:
	get = get_music_volume, set = set_music_volume

var sfx_volume: float:
	get = get_sfx_volume, set = set_sfx_volume

@onready var master_bus_index := AudioServer.get_bus_index("Master")
@onready var music_bus_index := AudioServer.get_bus_index("Music")
@onready var sfx_bus_index := AudioServer.get_bus_index("SFX")

func get_master_volume() -> float:
	return db_to_linear(
		AudioServer.get_bus_volume_db(master_bus_index)
	)

func set_master_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(
		master_bus_index,
		linear_to_db(value)
	)


func get_music_volume() -> float:
	return db_to_linear(
		AudioServer.get_bus_volume_db(music_bus_index)
	)

func set_music_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(
		music_bus_index,
		linear_to_db(value)
	)


func get_sfx_volume() -> float:
	return db_to_linear(
		AudioServer.get_bus_volume_db(sfx_bus_index)
	)

func set_sfx_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(
		sfx_bus_index,
		linear_to_db(value)
	)
