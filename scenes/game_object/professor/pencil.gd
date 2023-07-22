extends Node2D

var is_thrown = false
var velocity := Vector2.ZERO
var player: Node2D
@onready var despawn_timer := $Despawn

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)
	despawn_timer.timeout.connect(queue_free)
	player = get_tree().get_first_node_in_group("player") as Node2D

func _physics_process(delta):
	position += velocity * delta
	if not is_thrown:
		var target_position = player.global_position
		look_at(target_position)

func throw() -> void:
	is_thrown = true
	var target_position = player.global_position
	velocity = global_position.direction_to(target_position).normalized() * 500
	$Despawn.start()
