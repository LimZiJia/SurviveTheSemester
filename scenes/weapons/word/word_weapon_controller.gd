extends Node2D

@export var word_weapon_scene: PackedScene
@export var weapon_stat: WeaponStat

var can_attack := false

@onready var cooldown_timer := $CooldownTimer as Timer


func _ready():
	cooldown_timer.timeout.connect(on_cooldown_timer_timeout)
	GameEvents.weapon_upgrade_added.connect(on_weapon_upgrade_added)
	
	if weapon_stat != null:
		update_stats()


func _physics_process(_delta: float) -> void:
	if can_attack:
		spawn_weapon(weapon_stat.count)


# Sets the can_attack variable to true so that
# the player can attack again
func on_cooldown_timer_timeout() -> void:
	can_attack = true


func on_weapon_upgrade_added(weapon_upgrade: WeaponUpgrade) -> void:
	if weapon_upgrade.weapon_name != "Word":
		return
	
	weapon_stat = weapon_upgrade.weapon_stat
	update_stats()


func update_stats() -> void:
	cooldown_timer.wait_time = weapon_stat.cooldown
	if cooldown_timer.is_stopped():
		cooldown_timer.start()


# Given there are mobs surrounding the player, it initiates the cooldown, 
# and adds the given number of weapons into the world scene and facing the
# nearest mobs. Otherwise, it does nothing.
func spawn_weapon(number: int) -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var mob = find_nearest_mob() as Node2D
	if mob == null:
		return
	
	var mob_hitbox = mob.get("hitbox_component") as HitboxComponent
	var target_position: Vector2
	if mob_hitbox == null:
		target_position = mob.global_position
	else:
		target_position = mob_hitbox.global_position
	
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
