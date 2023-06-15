extends Node2D

@export var word_weapon_scene: PackedScene
@export var weapon_stat: WeaponStat

var can_attack := false

@onready var cooldown_timer := $CooldownTimer as Timer


func _ready():
	if weapon_stat == null:
		return
	cooldown_timer.wait_time = weapon_stat.cooldown
	cooldown_timer.timeout.connect(on_cooldown_timer_timeout)
	cooldown_timer.start()


func _physics_process(_delta: float) -> void:
	if can_attack:
		spawn_weapon(weapon_stat.count)


# Sets the can_attack variable to true so that
# the player can attack again
func on_cooldown_timer_timeout() -> void:
	can_attack = true

# Given there are mobs surrounding the player, it initiates the cooldown, 
# and adds the given number of weapons into the world scene and facing the
# nearest mobs. Otherwise, it does nothing.
func spawn_weapon(number: int) -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var mob = find_nearest_mob()
	if mob == null:
		return
	
	var target_position = mob.global_position
	
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	can_attack = false
	cooldown_timer.start()
	
	for i in number:
		var word_weapon_instance := word_weapon_scene.instantiate()
		var spawn_direction = global_position.direction_to(target_position)
		foreground.add_child(word_weapon_instance)
		
		word_weapon_instance.global_position = global_position
		word_weapon_instance.direction = spawn_direction
		word_weapon_instance.hitbox_component.damage = weapon_stat.damage
		word_weapon_instance.hitbox_component.knockback_force = weapon_stat.knockback
		await get_tree().create_timer(0.1, false).timeout


# Returns the nearest mob in the SceneTree, or null if 
# there are no mobs currently
func find_nearest_mob():
	var mobs = get_tree().get_nodes_in_group("mobs")
	var nearest = null
	var cur_dist = INF
	for mob in mobs:
		var dist = global_position.distance_to(mob.global_position)
		if dist < cur_dist:
			nearest = mob
			cur_dist = dist
	return nearest
