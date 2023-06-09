extends Node2D

@export var word_weapon_scene: PackedScene
@export_range(0.05, 10, 0.05) var cooldown := 1.00

var can_attack := true

@onready var cooldown_timer = $CooldownTimer


func _ready():
	cooldown_timer.timeout.connect(on_cooldown_timer_timeout)


func _process(_delta: float) -> void:
	if can_attack:
		attack()


# Given the player can attack and there are mobs surrounding the 
# player, it initiates the cooldown, and adds the word projectile
# to the SceneTree at its location and facing the nearest mob. 
# Otherwise, it does nothing.
func attack() -> void:
	if not can_attack:
		return
	var mob = find_mob()
	if not mob:
		return
	
	can_attack = false
	cooldown_timer.start(cooldown)
	
	var word_weapon_instance := word_weapon_scene.instantiate()
	var spawn_direction = global_position.direction_to(mob.global_position)
	
	var foreground_layer := get_tree().get_first_node_in_group("foreground_layer") as Node2D
	foreground_layer.add_child(word_weapon_instance)
	
	word_weapon_instance.global_position = global_position
	word_weapon_instance.direction = spawn_direction


# Sets the can_attack variable to true so that
# the player can attack again
func on_cooldown_timer_timeout() -> void:
	can_attack = true


# Out of all the mobs within 384 pixels of the player, within
# 60 degrees from the direction the player is facing, it returns
# the one best fitting its line of sight.
func find_mob() -> Node2D:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return null
	var facing := player.facing as Vector2
	
	var mobs = get_tree().get_nodes_in_group("mobs") as Array[Node2D]	
	mobs = mobs.filter(func(mob: Node2D) -> bool:
		return player.global_position.distance_squared_to(mob.global_position) <= pow(384, 2)
	)
	mobs = mobs.filter(func(mob: Node2D) -> bool:
		var direction = player.global_position.direction_to(mob.global_position)
		return abs(facing.angle_to(direction)) < PI / 3
	)
	if mobs.size() == 0:
		return null
	mobs.sort_custom(func(a: Node2D, b: Node2D) -> bool:
		var a_dir = player.global_position.direction_to(a.global_position)
		var b_dir = player.global_position.direction_to(b.global_position)
		
		return abs(facing.angle_to(a_dir)) < abs(facing.angle_to(b_dir))
	)
	return mobs[0]
