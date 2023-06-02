class_name WaveController
extends Node2D

@export var mob_scenes: Array[PackedScene] = [
	preload("res://characters/enemies/book/book.tscn"),
	preload("res://characters/enemies/mob/mob.tscn")
]
@export var mob_spawn_location: PathFollow2D

var wave_config: Array
var wave_multiplier: int
var score:int = 0

@onready var wave_timer := $WaveTimer as Timer

func _ready() -> void:
	randomize()
	var file_name = "res://config/wave_config.json"
	var file = FileAccess.open(file_name, FileAccess.READ)
	wave_config = JSON.parse_string(file.get_as_text())


func start() -> void:
	start_wave()


func stop() -> void:
	wave_timer.stop()

func start_wave() -> void:
	# Ensuring no errors
	if not mob_spawn_location:
		return
		
	var type = randi_range(0, 1)
	var cur_wave_config = wave_config[type]
	var count:int = count_scaling(cur_wave_config["count"], type)
	var health:float = health_scaling(cur_wave_config["health"], type)
	var speed:float = speed_scaling(cur_wave_config["speed"], type)
	var damage:float = damage_scaling(cur_wave_config["damage"], type)
	
	for i in range(count):
		mob_spawn_location.progress_ratio = randf()
		var mob = mob_scenes[type].instantiate()
		mob.position = mob_spawn_location.position
		mob.set_max_health(health)
		mob.speed = speed
		mob.set_damage(damage)
		add_child(mob)
	
	wave_timer.start(cur_wave_config["cooldown"])


# WAVE MULTIPLIERS
func count_scaling(count:int, type:int) -> int:
	match(type):
		# book
		0:
			count = count
		# mob
		1:
			count = count
			
	return count

func health_scaling(health:float, type:int) -> float:
	match(type):
	# book
		0:
			health = health
		# mob
		1:
			health = health
	
	return health

func speed_scaling(speed:float, type:int) -> float:
	match(type):
	# book
		0:
			speed = speed
		# mob
		1:
			speed = speed
	
	return speed

func damage_scaling(damage:float, type:int) -> float:
	match(type):
	# book
		0:
			damage = damage
		# mob
		1:
			damage = damage
	
	return damage
