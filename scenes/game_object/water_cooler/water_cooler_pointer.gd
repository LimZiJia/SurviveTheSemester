extends Node2D

@onready var sprite_2d := $Sprite2D as Sprite2D


func _ready() -> void:
	play_entry_scaling()


func _process(_delta: float) -> void:
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size / canvas.get_scale()
	
	set_pointer_position(Rect2(top_left, size))
	set_pointer_rotation()


func play_entry_scaling() -> void:
	var tween = create_tween()
	sprite_2d.scale = 6.0 * Vector2.ONE
	tween.tween_property(sprite_2d, "scale", Vector2.ONE, 2)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)


func set_pointer_position(bounds: Rect2) -> void:
	var camera_position := bounds.get_center()
	
	var displacement := global_position - camera_position
	var angle := displacement.angle()
	var length: float
	
	# Obtaining angles to each of the corners from the center of viewport
	var tl = camera_position.angle_to_point(bounds.position)
	var tr = camera_position.angle_to_point(Vector2(bounds.end.x, bounds.position.y))
	var bl = camera_position.angle_to_point(Vector2(bounds.position.x, bounds.end.y))
	var br = camera_position.angle_to_point(bounds.end)
	
	# Determining which side of the viewport to place the pointer
	if (angle > tl and angle < tr) or (angle < bl and angle > br):
		var y_length = clampf(displacement.y, 
			bounds.position.y - camera_position.y,
			bounds.end.y - camera_position.y)
		var triangle_angle = angle - PI / 2.0
		length = y_length / cos(triangle_angle) if cos(triangle_angle) != 0 else y_length
	else:
		var x_length = clampf(displacement.x, 
			bounds.position.x - camera_position.x,
			bounds.end.x - camera_position.x)
		length = x_length / cos(angle) if cos(angle) != 0 else x_length
	
	sprite_2d.global_position = Vector2.from_angle(angle) * length + camera_position
	
	if bounds.has_point(global_position):
		hide()
	else:
		show()


func set_pointer_rotation():
	var angle := sprite_2d.global_position.angle_to_point(global_position)
	sprite_2d.global_rotation = angle
