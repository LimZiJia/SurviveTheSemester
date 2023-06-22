extends Node2D

# Each dictionary has the following structure:
# {
#   "scene": PackedScene,
#   "weight": int,
#   "cost": int
# }
@export var enemies: Array[Dictionary] = []

@export var min_wave_time := 5.0
@export var max_wave_time := 20.0

var cur_wave: int = 1
var enemy_table := WeightedTable.new()

@onready var marker_2d := $Marker2D as Marker2D

func _ready() -> void:
	# TODO: Start with only certain enemies
	for enemy in enemies:
		enemy_table.add_item(enemy, enemy.weight)
	$Timer.timeout.connect(on_timer_timeout)
	start_wave()


func on_timer_timeout() -> void:
	# TODO: Add certain mobs at certain times/waves
	start_wave()


func get_cur_wave_cost(wave_time: float) -> float:
	# TODO: Create mathematical formula for cost
	return cur_wave * wave_time


func get_spawn_position() -> Vector2:
	# TODO: Create more extensive algorithm to determine mob spawn position
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	while true:
		var spawn_position := player.global_position + Vector2.from_angle(randf_range(0, TAU)) * 720.0
		if absf(spawn_position.x) < 1160.0 and absf(spawn_position.y) < 680.0:
			return spawn_position
	
	return Vector2.ZERO


func start_wave() -> void:
	cur_wave += 1
	
	var wave_time := randf_range(min_wave_time, max_wave_time)
	$Timer.wait_time = wave_time
	
	var total_cost = get_cur_wave_cost(wave_time)
	
	var entities = get_tree().get_first_node_in_group("entities_layer") as Node2D
	if entities == null:
		return
	
	while total_cost > 0:
		var enemy = enemy_table.pick_item()
		var enemy_instance = enemy.scene.instantiate() as Node2D
		
		entities.add_child(enemy_instance)
		enemy_instance.global_position = get_spawn_position()
		# TODO: Add mechanism for each mob to set stats based on difficulty
		
		total_cost -= enemy.cost
	
	$Timer.start()
