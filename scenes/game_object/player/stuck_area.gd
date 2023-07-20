extends Area2D

signal stuck(safe_position: Vector2)

var area: Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$CheckingInterval.timeout.connect(on_check_interval_timeout)
	$CheckingInterval.start()


func on_check_interval_timeout() -> void:
	check_stuck()


func check_stuck() -> void:
	var new_area = get_overlapping_areas()
	if new_area.is_empty():
		area = null
	elif area == null or area != new_area[0]:
		area = new_area[0]
	else:
		calc_safe_pos(area)


func calc_safe_pos(area: Area2D) -> void:
	if not area is WorldObject:
		return
	
	var pos: Vector2
	var object_collision = area.get_child(0)
	var obj_x = object_collision.global_position.x
	var obj_y = object_collision.global_position.y
	var delta_x = obj_x - global_position.x
	var delta_y = obj_y - global_position.y
	var shape: RectangleShape2D = object_collision.shape
	var half_width = shape.size.x / 2
	var half_height = shape.size.y / 2
	# Distance to exit shape
	if half_width - abs(delta_x) < half_height - abs(delta_y):
		var x = obj_x - half_width - 30.0 if delta_x > 0 else obj_x + half_width + 30.0
		pos = Vector2(x, global_position.y)
	else:
		var y = obj_y - half_height - 30.0 if delta_y > 0 else obj_y + half_height + 30.0
		pos = Vector2(global_position.x, y)
	stuck.emit(pos)
