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

func _ready() -> void:
	# TODO: Start with only certain enemies
	enemy_table.add_item(
		{
			"cost": 2.0,
			"scene": preload("res://scenes/game_object/mob/mob.tscn"),
			"weight": 100,
		},
		60
	)
	enemy_table.add_item(
		{
			"cost": 2.4,
			"scene": preload("res://scenes/game_object/book/book.tscn"),
			"weight": 80,
		},
		40)
	enemy_table.add_item(
		{
			"cost": 1.0,
			"scene": preload("res://scenes/game_object/professor/professor.tscn"),
			"weight": 20,
		},
		20)
	$Timer.timeout.connect(on_timer_timeout)
	start_wave()


func on_timer_timeout() -> void:
	# TODO: Add certain mobs at certain times/waves
	match cur_wave:
		5: enemy_table.add_item(
			{
				"cost": 2.0,
				"scene": preload("res://scenes/game_object/exam_paper/exam_paper.tscn"),
				"weight": 20,
			},
			20)
		8: enemy_table.add_item(
			{
				"cost": 3.0,
				"scene": preload("res://scenes/game_object/printer/printer.tscn"),
				"weight": 10,
			},
			10)
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
	var spawn_polygons = get_tree().get_nodes_in_group("spawn_polygon") as Array[Polygon2D]
	if spawn_polygons.size() == 0:
		return Vector2.ZERO
	
	var polygon_table = WeightedTable.new()
	for spawn_polygon in spawn_polygons:
		var points = spawn_polygon.polygon
		polygon_table.add_item(points, Geometry2DPlus.area(points))
	
	var chosen_polygon = polygon_table.pick_item()
	
	return Geometry2DPlus.rand_point(chosen_polygon)


func start_wave() -> void:
	cur_wave += 1
	
	var target_cost = get_target_cost()
	var actual_cost: int = 0
	
	var entities = get_tree().get_first_node_in_group("entities_layer") as Node2D
	if entities == null:
		return
	
	var spawn_tween = create_tween()
	
	while target_cost > 0:
		var enemy = enemy_table.pick_item()
		var enemy_instance = enemy.scene.instantiate() as Node2D
		enemy_instance.global_position = get_spawn_position()
		
		# TODO: Add mechanism for each mob to set stats based on difficulty
		enemy_instance.set_difficulty(cur_wave)
		
		spawn_tween.tween_callback(entities.add_child.bind(enemy_instance))
		spawn_tween.tween_interval(enemy.cost)
		
		target_cost -= enemy.cost
		actual_cost += enemy.cost
	
	$Timer.wait_time = actual_cost + randf_range(-2.0, 3.0)
	$Timer.start()
