extends Node2D

const MIN_SPAWN_RADIUS := 720.0
const MAX_SPAWN_RADIUS := 1080.0

# Each dictionary has the following structure:
# {
#   "scene": PackedScene,
#   "weight": int,
#   "cost": int
# }
@export var enemies: Array[Dictionary] = []

var cur_wave: int = 1
var enemy_table := WeightedTable.new()

@onready var marker_2d := $Marker2D as Marker2D

func _ready() -> void:
	# TODO: Start with only certain enemies
	enemy_table.add_item(
		{
			"cost": 2.0,
			"scene": preload("res://scenes/game_object/mob/mob.tscn"),
			"weight": 60,
		},
		60
	)
	
	$Timer.timeout.connect(on_timer_timeout)
	start_wave()


func on_timer_timeout() -> void:
	# TODO: Add certain mobs at certain times/waves
	match cur_wave:
		5: enemy_table.add_item(
			{
				"cost": 2.4,
				"scene": preload("res://scenes/game_object/book/book.tscn"),
				"weight": 40,
			},
			40)
		10: enemy_table.add_item(
			{
				"cost": 30,
				"scene": preload("res://scenes/game_object/bookshelf/bookshelf.tscn"),
				"weight": 2,
			},
			2)
	start_wave()


func get_target_cost() -> float:
	# TODO: Create mathematical formula for cost
	return 6 * log(cur_wave) + 10


func get_spawn_position() -> Vector2:
	# TODO: Create more extensive algorithm to determine mob spawn position
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	while true:
		var spawn_radius := randf_range(MIN_SPAWN_RADIUS, MAX_SPAWN_RADIUS)
		var spawn_position := player.global_position + Vector2.from_angle(randf_range(0, TAU)) * spawn_radius
		if absf(spawn_position.x) < 1160.0 and absf(spawn_position.y) < 680.0:
			return spawn_position
	
	return Vector2.ZERO


func start_wave() -> void:
	cur_wave += 1
	
	var target_cost = get_target_cost()
	var actual_cost: int = 0
	
	var entities = get_tree().get_first_node_in_group("entities_layer") as Node2D
	if entities == null:
		return
	
	while target_cost > 0:
		var enemy = enemy_table.pick_item()
		var enemy_instance = enemy.scene.instantiate() as Node2D
		enemy_instance.global_position = get_spawn_position()
		
		# TODO: Add mechanism for each mob to set stats based on difficulty
		enemy_instance.set_difficulty(cur_wave)
		
		entities.add_child(enemy_instance)
		
		
		target_cost -= enemy.cost
		actual_cost += enemy.cost
	
	$Timer.wait_time = actual_cost + randf_range(-2.0, 3.0)
	$Timer.start()
