extends RigidBody2D

var target = null
var speed = 100.0
@onready var screen_size = get_viewport_rect().size
@onready var dmg = randi_range(5, 20)


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


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


func _on_detection_area_area_entered(area):
	var player := area as Player
	if player:
		target = area


func _on_detection_area_area_exited(area):
	var player := area as Player
	if player:
		target = null
