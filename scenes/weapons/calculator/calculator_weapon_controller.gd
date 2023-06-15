extends Node2D

@export var calculator_scene: PackedScene
@export var weapon_stat: WeaponStat

@onready var cooldown_timer := $CooldownTimer as Timer


func _ready() -> void:
	if weapon_stat == null:
		return
	
	cooldown_timer.wait_time = weapon_stat.cooldown
	cooldown_timer.timeout.connect(on_cooldown_timer_timeout)
	cooldown_timer.start()


func on_cooldown_timer_timeout() -> void:
	spawn_weapon(weapon_stat.count)


# Spawns the given number of weapons into the world scene.
func spawn_weapon(number: int) -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var base_rotation := randf_range(0, TAU)
	
	var angle_between = TAU / number
	for i in number:
		var calculator_instance = calculator_scene.instantiate() as Node2D
		calculator_instance.attack_time = weapon_stat.metadata["attack_time"]
		calculator_instance.outer_rotation = base_rotation + i * angle_between
		foreground.add_child(calculator_instance)
		calculator_instance.hitbox_component.damage = weapon_stat.damage
		calculator_instance.hitbox_component.knockback_force = weapon_stat.knockback
