extends RigidBody2D

@export var speed := 100.0
@onready var screen_size := get_viewport_rect().size
var target: Player = null



func _physics_process(delta):
	var direction = Vector2.ZERO
	
	if target:
		direction = position.direction_to(target.position)
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += direction * speed * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func _on_detection_area_area_entered(area: Player):
	target = area


func _on_detection_area_area_exited(_area: Player):
	target = null
