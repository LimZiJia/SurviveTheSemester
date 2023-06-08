extends Node

@export var mob_scenes: Array[PackedScene] = []

@export var time_manager: Node

enum {BOOK, MOB, INTERMEDIATE_BOOK, INTERMEDIATE_MOB, BOSS_BOOK}

var wave_mobs: Array
var introduction_rounds: Dictionary

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
@onready var mob_spawn_location := %MobSpawnLocation as PathFollow2D

func _ready() -> void:
	randomize()
	var file_name = "res://config/wave_config.json"
	var file = FileAccess.open(file_name, FileAccess.READ)
	var temp = JSON.parse_string(file.get_as_text())
	wave_mobs = temp["mob"]
	introduction_rounds = temp["introduction_rounds"]
	
	start_wave()


func _process(_delta: float) -> void:
	if time_manager == null:
		return
	var time = int(time_manager.get_time_elapsed())
	
	# Should not change the probabilities until the first intermediate wave/ boss wave
	if (not intermediate_wave):
		prev_increase = time
	
	# First catch is for if the boss wave has occured
	if (boss_wave and time - prev_increase >= 20 and \
			time >= introduction_rounds["boss"]["score"] + \
						introduction_rounds["boss"]["cooldown"]):
		print("Boss chance increase")
		prev_increase = time
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
	elif (intermediate_wave and time - prev_increase >= 20 and not boss_wave \
			and time >= introduction_rounds["intermediate"]["score"] + \
							introduction_rounds["intermediate"]["cooldown"]):
		print("Intermediate chance increase")
		prev_increase = time
		p_intermediate = clampf(p_intermediate + 0.05, 0.0, 1.0)
		p_easy = clampf(p_easy - 0.05, 0.0, 1.0)
		print(p_easy)
		print(p_intermediate)
		print(p_boss)


func start_wave() -> void:
	# Ensuring no errors
	if not mob_spawn_location:
		return
	if time_manager == null:
		return
	var time = int(time_manager.get_time_elapsed())
	
	# Special waves (want to introduce intermediate/hard mobs at set score)
	# Intermediate special wave
	if (not intermediate_wave and \
	time >= introduction_rounds["intermediate"]["score"]):
		print("Intermediate special wave")
		intermediate_wave = true

		for i in range(2, 4):
			var count:int = wave_mobs[i]["count"]
			var health:float = wave_mobs[i]["health"]
			var speed:float = wave_mobs[i]["speed"]
			var damage:float = wave_mobs[i]["damage"]
			spawn_mob1(count, i, health, speed, damage)
		wave_timer.start(introduction_rounds["intermediate"]["cooldown"])
		
		# Set probabilities for normal waves
		p_intermediate = 0.25
		p_easy = 0.75
	# Boss special wave
	elif (not boss_wave and \
	time >= introduction_rounds["boss"]["score"]):
		print("Boss special wave")
		boss_wave = true
		var count:int = wave_mobs[4]["count"]
		var health:float = wave_mobs[4]["health"]
		var speed:float = wave_mobs[4]["speed"]
		var damage:float = wave_mobs[4]["damage"]
		var cooldown:float = introduction_rounds["boss"]["cooldown"]
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
		return randi_range(BOOK, MOB)
	elif (temp <= p_easy + p_intermediate):
		print("intermediate spawned")
		print(p_easy)
		print(p_intermediate)
		print(p_boss)
		print(temp)
		return randi_range(INTERMEDIATE_BOOK, INTERMEDIATE_MOB)
	else:
		print("boss spawned")
		print(p_easy)
		print(p_intermediate)
		print(p_boss)
		print(temp)
		return BOSS_BOOK

func spawn_mob(\
count:int, type:int, health:float, speed:float, damage:float, cooldown:float) -> void:
	spawn_mob1(count, type, health, speed, damage)
	wave_timer.start(cooldown)

# spawn_mob without the cooldown
func spawn_mob1(
count:int, type:int, health:float, speed:float, damage:float) -> void:
	for i in range(count):
		mob_spawn_location.progress_ratio = randf()
		var mob = mob_scenes[type].instantiate()
		mob.position = mob_spawn_location.position
		
		var entities_layer = get_tree().get_first_node_in_group("entities_layer") as Node2D
		entities_layer.add_child(mob)
		
		mob.set_stats(health, speed, damage)




# SCORE MULTIPLIERS
func count_scaling(count:int, type:int) -> int:
	match(type):
		BOOK:
			count = count
		
		MOB:
			count = count
		
		INTERMEDIATE_BOOK:
			count = count
		
		INTERMEDIATE_MOB:
			count = count
		
		BOSS_BOOK:
			count = count
			
	return count

func health_scaling(health:float, type:int) -> float:
	match(type):
		BOOK:
			health = health
		
		MOB:
			health = health
		
		INTERMEDIATE_BOOK:
			health = health
		
		INTERMEDIATE_MOB:
			health = health
		
		BOSS_BOOK:
			health = health
	
	return health

func speed_scaling(speed:float, type:int) -> float:
	match(type):
		BOOK:
			speed = speed
		
		MOB:
			speed = speed
		
		INTERMEDIATE_BOOK:
			speed = speed
		
		INTERMEDIATE_MOB:
			speed = speed
		
		BOSS_BOOK:
			speed = speed
	
	return speed

func damage_scaling(damage:float, type:int) -> float:
	match(type):
		BOOK:
			damage = damage
		
		MOB:
			damage = damage
		
		INTERMEDIATE_BOOK:
			damage = damage
		
		INTERMEDIATE_MOB:
			damage = damage
		
		BOSS_BOOK:
			damage = damage
	
	return damage
	
func cooldown_scaling(cooldown:float, type:int) -> float:
	match(type):
		BOOK:
			cooldown = cooldown
		
		MOB:
			cooldown = cooldown
		
		INTERMEDIATE_BOOK:
			cooldown = cooldown
		
		INTERMEDIATE_MOB:
			cooldown = cooldown
		
		BOSS_BOOK:
			cooldown = cooldown
	
	return cooldown
