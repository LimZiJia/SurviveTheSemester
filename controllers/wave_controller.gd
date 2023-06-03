class_name WaveController
extends Node2D

@export var mob_scenes: Array[PackedScene] = [
	preload("res://characters/enemies/book/book.tscn"),
	preload("res://characters/enemies/mob/mob.tscn"),
	preload("res://characters/enemies/book/book.tscn"),
	preload("res://characters/enemies/mob/mob.tscn"),
	preload("res://characters/enemies/book/book.tscn")
]

@export var mob_spawn_location: PathFollow2D

var wave_mobs: Array
var introduction_rounds: Dictionary
var score:int = 0

# Flags for if intermediate/boss mobs have been introduced
var intermediate_wave:bool = false
var boss_wave:bool = false

# Probability to spawn these mobs
var p_easy:float = 1.0
var p_intermediate:float = 0.0
var p_boss:float = 0.0

# For controlling probability increasing
var prev_increase:int = 0

@onready var wave_timer := $WaveTimer as Timer

func _ready() -> void:
	randomize()
	var file_name = "res://config/wave_config.json"
	var file = FileAccess.open(file_name, FileAccess.READ)
	var temp = JSON.parse_string(file.get_as_text())
	wave_mobs = temp["mob"]
	introduction_rounds = temp["introduction_rounds"]


func _process(delta) -> void:
	# Should not change the probabilities until the first intermediate wave/ boss wave
	if (not intermediate_wave):
		prev_increase = score
	
	# First catch is for if the boss wave has occured
	if (boss_wave and score - prev_increase >= 20):
		print("Boss chance increase")
		prev_increase = score
		if (p_easy == 0.0):
			p_boss = clampf(p_boss + 0.05, 0.0, 1.0)
			p_intermediate = clampf(p_intermediate - 0.05, 0.0, 1.0)
		else:
			p_boss = clampf(p_boss + 0.05, 0.0, 1.0)
			p_easy = clampf(p_easy - 0.05, 0.0, 1.0)
		print(p_easy)
		print(p_intermediate)
		print(p_boss)
	
	# Second catch is for if the intermediate wave has occurred, but not the boss wave
	elif (intermediate_wave and score - prev_increase >= 20):
		print("Intermediate chance increase")
		prev_increase = score
		p_intermediate = clampf(p_intermediate + 0.05, 0.0, 1.0)
		p_easy = clampf(p_easy - 0.05, 0.0, 1.0)
		print(p_easy)
		print(p_intermediate)
		print(p_boss)


func start() -> void:
	start_wave()


func stop() -> void:
	wave_timer.stop()

func start_wave() -> void:
	# Ensuring no errors
	if not mob_spawn_location:
		return
	
	# Special waves (want to introduce intermediate/hard mobs at set score)
	# Intermediate special wave
	if (not intermediate_wave and \
	score >= introduction_rounds["intermediate"]["score"]):
		print("Intermediate special wave")
		intermediate_wave = true
		var wave_cooldown:float = 0.0
		for i in range(2, 4):
			var count:int = wave_mobs[i]["count"]
			var health:float = wave_mobs[i]["health"]
			var speed:float = wave_mobs[i]["speed"]
			var damage:float = wave_mobs[i]["damage"]
			wave_cooldown += wave_mobs[i]["cooldown"]
			spawn_mob1(count, i, health, speed, damage)
		wave_timer.start(wave_cooldown)
		
		# Set probabilities for normal waves
		p_intermediate = 0.25
		p_easy = 0.75
	# Boss special wave
	elif (not boss_wave and \
	score >= introduction_rounds["boss"]["score"]):
		print("Boss special wave")
		boss_wave = true
		var count:int = wave_mobs[4]["count"]
		var health:float = wave_mobs[4]["health"]
		var speed:float = wave_mobs[4]["speed"]
		var damage:float = wave_mobs[4]["damage"]
		var cooldown:float = wave_mobs[4]["cooldown"]
		spawn_mob(count, 4, health, speed, damage, cooldown)
		
		# Set probabilites for normal waves
		p_boss = 0.1
		p_intermediate = 0.6
		p_easy = 0.4
	
	
	# Normal waves
	else:
		# Choosing type of mob (easy, intermediate, hard)
		var type = choose_type()
		var cur_wave_config = wave_mobs[type]
		
		
		var count:int = count_scaling(cur_wave_config["count"], type)
		var health:float = health_scaling(cur_wave_config["health"], type)
		var speed:float = speed_scaling(cur_wave_config["speed"], type)
		var damage:float = damage_scaling(cur_wave_config["damage"], type)
		var cooldown:float = cooldown_scaling(cur_wave_config["cooldown"], type)
		
		spawn_mob(count, type, health, speed, damage, cooldown)

# Type returned is just the index of mob_scenes: Array[PackedScene]
func choose_type() -> int:
	var temp = randf()
	if (temp <= p_easy):
		print("easy spawned")
		print(p_easy)
		print(p_intermediate)
		print(p_boss)
		print(temp)
		return randi_range(0, 1)
	elif (temp <= p_easy + p_intermediate):
		print("intermediate spawned")
		print(p_easy)
		print(p_intermediate)
		print(p_boss)
		print(temp)
		return randi_range(2, 3)
	else:
		print("boss spawned")
		print(p_easy)
		print(p_intermediate)
		print(p_boss)
		print(temp)
		return 4

func spawn_mob(\
count:int, type:int, health:float, speed:float, damage:float, cooldown:float) -> void:
	for i in range(count):
			mob_spawn_location.progress_ratio = randf()
			var mob = mob_scenes[type].instantiate()
			mob.position = mob_spawn_location.position
			mob.set_max_health(health)
			mob.speed = speed
			mob.set_damage(damage)
			add_child(mob)
	wave_timer.start(cooldown)

# spawn_mob without the cooldown
func spawn_mob1(\
count:int, type:int, health:float, speed:float, damage:float) -> void:
	for i in range(count):
			mob_spawn_location.progress_ratio = randf()
			var mob = mob_scenes[type].instantiate()
			mob.position = mob_spawn_location.position
			mob.set_max_health(health)
			mob.speed = speed
			mob.set_damage(damage)
			add_child(mob)



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
	
func cooldown_scaling(cooldown:float, type:int) -> float:
	match(type):
	# book
		0:
			cooldown = cooldown
		# mob
		1:
			cooldown = cooldown
	
	return cooldown
