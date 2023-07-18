extends Node2D

signal spawned(position: Vector2)

@export var water_cooler_scene: PackedScene
@export var navigation_region: NavigationRegion2D

@onready var timer := $Timer as Timer

func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)


func on_timer_timeout() -> void:
	spawn_water_cooler()


func spawn_water_cooler() -> void:
	var entities = get_tree().get_first_node_in_group("entities_layer") as Node2D
	if entities == null:
		return
	
	var water_cooler_instance = water_cooler_scene.instantiate() as WaterCooler
	
	entities.add_child(water_cooler_instance)
	water_cooler_instance.global_position = get_spawn_position()
	water_cooler_instance.collected.connect(on_water_cooler_collected)
	
	spawned.emit(global_position)
	print("spawned")


func on_water_cooler_collected() -> void:
	timer.start()


func get_spawn_position() -> Vector2:
	if navigation_region == null:
		return Vector2.ZERO
	
	var navigation_polygon := navigation_region.navigation_polygon
	if navigation_polygon.get_polygon_count() == 0:
		return Vector2.ZERO
	
	var polygon_table = WeightedTable.new()
	for poly_idx in navigation_polygon.get_polygon_count():
		var polygon := Geometry2DPlus.make_polygon(
			navigation_polygon.get_polygon(poly_idx), 
			navigation_polygon.get_vertices())
		polygon_table.add_item(polygon, Geometry2DPlus.area(polygon))
	
	return Geometry2DPlus.rand_point(polygon_table.pick_item())
