extends Node

@export var code_weapon_scene: PackedScene
@export var weapon_stat: WeaponStat

var can_attack := true

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
	if weapon_upgrade.weapon_name != "Code":
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
	
	var spawn_position = player.global_position

	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	can_attack = false
	cooldown_timer.start()
	
	
	for i in number:
		var code_weapon_instance := code_weapon_scene.instantiate()
		code_weapon_instance.global_position = spawn_position
		code_weapon_instance.set_damage_knockback(weapon_stat.damage, weapon_stat.knockback)
		foreground.add_child(code_weapon_instance)
		
		
