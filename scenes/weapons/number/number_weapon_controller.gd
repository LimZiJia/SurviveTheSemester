extends Node

@export var number_weapon_scene: PackedScene
@export var weapon_stat: WeaponStat

var can_attack := false

@onready var cooldown_timer := $CooldownTimer as Timer


func _ready():
	cooldown_timer.timeout.connect(on_cooldown_timer_timeout)
	GameEvents.weapon_upgrade_added.connect(on_weapon_upgrade_added)
	
	if weapon_stat != null:
		update_stats()


func _physics_process(_delta: float):
	if can_attack:
		spawn_weapon(weapon_stat.count)


# Sets the can_attack variable to true so that
# the player can attack again
func on_cooldown_timer_timeout() -> void:
	can_attack = true


func on_weapon_upgrade_added(weapon_upgrade: WeaponUpgrade) -> void:
	if weapon_upgrade.weapon_name != "Number":
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
	
	var mob = find_nearest_mob()
	if mob == null:
		return
	
	var spawn_position = mob.global_position
	
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	can_attack = false
	cooldown_timer.start()
	
	for i in number:
		var number_weapon_instance := number_weapon_scene.instantiate()
		foreground.add_child(number_weapon_instance)
		number_weapon_instance.global_position = spawn_position
		number_weapon_instance.hitbox_component.damage = weapon_stat.damage
		number_weapon_instance.hitbox_component.knockback_force = weapon_stat.knockback
		
		await get_tree().create_timer(.05, false).timeout


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
