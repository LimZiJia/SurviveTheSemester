extends Node2D

@export var word_projectile_scene: PackedScene
@export_range(0.05, 10, 0.05) var cooldown := 0.05

var can_attack := true

@onready var cooldown_timer = $CooldownTimer


func _ready():
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)



func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		attack()
		

# Given the player can attack and there are mobs surrounding the 
# player, it initiates the cooldown, and adds the word projectile
# to the SceneTree at its location and facing the nearest mob. 
# Otherwise, it does nothing.
func attack() -> void:
	if not can_attack:
		return
	var mob = find_nearest_mob()
	if not mob:
		return
	
	can_attack = false
	cooldown_timer.start(cooldown)
	
	var word_projectile := word_projectile_scene.instantiate()
	word_projectile.position = global_position
	word_projectile.direction = global_position.direction_to(mob.global_position)
	add_child(word_projectile)



# Sets the can_attack variable to true so that
# the player can attack again
func _on_cooldown_timer_timeout() -> void:
	can_attack = true

# Despawns the word after some time


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
