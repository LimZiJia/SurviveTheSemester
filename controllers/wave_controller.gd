class_name WaveController
extends Node2D

@export var mob_scene: PackedScene
@export var mob_spawn_location: PathFollow2D

var cur_wave:int = 0
var wave_config: Array

@onready var wave_timer := $WaveTimer as Timer

func _ready() -> void:
	randomize()
	var file_name = "res://config/wave_config.json"
	var file = FileAccess.open(file_name, FileAccess.READ)
	wave_config = JSON.parse_string(file.get_as_text())


func start() -> void:
	cur_wave = 0
	start_wave()


func stop() -> void:
	wave_timer.stop()

func start_wave() -> void:
	# Ensuring no errors
	if not mob_spawn_location:
		return
	if cur_wave >= wave_config.size():
		return
	
	var cur_wave_config = wave_config[cur_wave]
	
	for i in range(cur_wave_config["count"]):
		mob_spawn_location.progress_ratio = randf()
		var mob = mob_scene.instantiate()
		mob.position = mob_spawn_location.position
		mob.set_max_health(cur_wave_config["health"])
		mob.speed = cur_wave_config["speed"]
		mob.set_damage(cur_wave_config["damage"])
		add_child(mob)
	
	wave_timer.start(cur_wave_config["cooldown"])
	cur_wave += 1
