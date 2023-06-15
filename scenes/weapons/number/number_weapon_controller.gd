extends Node

@export var number_weapon_scene: PackedScene
@export_range(0.05, 10, 0.05) var cooldown := 0.05

var can_attack := true

@onready var cooldown_timer = $CooldownTimer


func _ready():
	cooldown_timer.timeout.connect(on_cooldown_timer_timeout)


func _physics_process(delta: float):
	attack()

func attack() -> void:
	if not can_attack:
		return
	var mob = find_nearest_mob()
	if not mob:
		return
	
	can_attack = false
	cooldown_timer.start(cooldown)
	
	for i in 3:
		var number_weapon_instance := number_weapon_scene.instantiate()
		var foreground_layer := get_tree().get_first_node_in_group("foreground_layer") as Node2D
		foreground_layer.add_child(number_weapon_instance)
		number_weapon_instance.global_position = mob.global_position
		
		await get_tree().create_timer(.05).timeout



# Sets the can_attack variable to true so that
# the player can attack again
func on_cooldown_timer_timeout() -> void:
	can_attack = true


# Returns the nearest mob in the SceneTree, or null if 
# there are no mobs currently
func find_nearest_mob():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return null
	
	var mobs = get_tree().get_nodes_in_group("mobs") as Array[Node2D]
	mobs = mobs.filter(func(mob: Node2D):
		return player.global_position.distance_squared_to(mob.global_position) <= pow(320, 2.0)
	)
	
	if mobs.size() == 0:
		return null
	
	mobs.sort_custom(func(a: Node2D, b: Node2D):
		var a_dist = player.global_position.distance_squared_to(a.global_position)
		var b_dist = player.global_position.distance_squared_to(b.global_position)
		return a_dist < b_dist
	)
	
	return mobs[0]
