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


# Returns the area of a triangle given an array of the points of the triangle
func triangle_area(points: PackedVector2Array) -> float:
	assert(points.size() == 3)
	
	return 0.5 * (\
		(points[1].x - points[0].x) * (points[2].y - points[0].y) - \
		(points[2].x - points[0].x) * (points[1].y - points[0].y) \
	)


# Returns a random point in the triangle given an array of the points of the triangle
# Based on https://www.cs.princeton.edu/~funk/tog02.pdf
func random_triangle_point(points: PackedVector2Array) -> Vector2:
	assert(points.size() == 3)
	
	var a := points[0]
	var b := points[1]
	var c := points[2]
	
	return a + sqrt(randf()) * (-a + b + randf() * (c - b))


func get_spawn_position() -> Vector2:
	
	# An array of arrays containing three points each
	var triangle_pool: Array[PackedVector2Array]
	var triangle_weight_pool: Array[float]
	var sum_area := 0.0
	
	# Triangulate all polygons
	var spawn_polygons = get_tree().get_nodes_in_group("spawn_polygon") as Array[Polygon2D]
	for spawn_polygon in spawn_polygons:
		var points = spawn_polygon.polygon
		var triangulated_points := Geometry2D.triangulate_polygon(points)
		
		for index in len(triangulated_points) / 3:
			var triangle: PackedVector2Array
			
			for n in range(3):
				triangle.append(points[triangulated_points[(index * 3) + n]])
			
			var area := triangle_area(triangle)
			
			triangle_pool.append(triangle)
			triangle_weight_pool.append(area)
			sum_area += area
	
	# Choose a random triangle with chance proportional to area
	var rnd_float = randf_range(0, sum_area)
	var chosen_triangle: PackedVector2Array
	for index in len(triangle_pool):
		if rnd_float <= triangle_weight_pool[index]:
			chosen_triangle = triangle_pool[index]
			break
		rnd_float -= triangle_weight_pool[index]
	
	
	# Choose a random point in the triangle
	return random_triangle_point(chosen_triangle)


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
