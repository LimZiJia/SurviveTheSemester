extends Node2D

var is_thrown = false
var velocity := Vector2.ZERO
@onready var despawn_timer = $Despawn

# Called when the node enters the scene tree for the first time.
func _ready():
	despawn_timer.timeout.connect(queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if not is_thrown:
		var target_position = player.global_position
		look_at(global_position.direction_to(target_position))

func _physics_process(delta):
	position = velocity * delta

func throw() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	var target_position = player.global_position
	velocity = global_position.direction_to(target_position).normalized() * 5
	despawn_timer.start()
