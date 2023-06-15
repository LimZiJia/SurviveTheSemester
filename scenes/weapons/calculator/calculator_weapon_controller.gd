extends Node2D

@export var calculator_scene: PackedScene

@onready var timer = $Timer

var damage: float = 10.0
var cooldown_time: float = 7.0
var base_attack_time := 4.0
var attack_time: float
var number: int = 1


func _ready() -> void:
	attack_time = base_attack_time
	
	timer.wait_time = cooldown_time
	timer.start()
	timer.timeout.connect(on_timer_timeout)


func on_timer_timeout() -> void:
	spawn_mobs(number)


func spawn_mobs(amount: int) -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var base_rotation := randf_range(0, TAU)
	
	var angle_between = TAU / amount
	for i in amount:
		var calculator_instance = calculator_scene.instantiate() as Node2D
		calculator_instance.attack_time = attack_time
		calculator_instance.outer_rotation = base_rotation + i * angle_between
		foreground.add_child(calculator_instance)
		calculator_instance.hitbox_component.damage = damage
