class_name WaveController
extends Node2D

@export var mob_scene: PackedScene
@export var mob_spawn_location: PathFollow2D

const MOB_NUMBER := [5, 10, 20, 40, 8]
const MOB_SPEED := [75.0, 100.0, 200.0, 50.0, 250.0]
const MOB_HEALTH := [10.0, 10.0, 5.0, 50.0, 5.0]
const MOB_DAMAGE := [5.0, 10.0, 5.0, 20.0, 10.0]
const COOLDOWN := [10.0, 10.0, 10.0, 15.0, 15.0]

var cur_wave := 0

func _ready() -> void:
	randomize()


func _process(delta: float) -> void:
	pass


func start() -> void:
	# Restart
	cur_wave = 0
	start_wave()


func stop() -> void:
	$WaveTimer.stop()

func start_wave() -> void:
	# Ensuring no errors
	if not mob_spawn_location:
		return
	if cur_wave >= MOB_NUMBER.size():
		return
	
	for i in range(MOB_NUMBER[cur_wave]):
		mob_spawn_location.progress_ratio = randf()
		var mob = mob_scene.instantiate()
		mob.position = mob_spawn_location.position
		mob.speed = MOB_SPEED[cur_wave]
		mob.set_max_health(MOB_HEALTH[cur_wave])
		mob.set_damage(MOB_DAMAGE[cur_wave])
		add_child(mob)
	
	$WaveTimer.start(COOLDOWN[cur_wave])
	cur_wave += 1
